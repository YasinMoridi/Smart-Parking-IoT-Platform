package com.yasin.smartparking.core.network

import com.yasin.smartparking.feature.parking.domain.ParkingState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.PrintWriter
import java.net.InetSocketAddress
import java.net.Socket

class ParkingSocketClient {
    private var socket: Socket? = null
    private var writer: PrintWriter? = null
    private val mutex = Mutex()
    private val json = Json { ignoreUnknownKeys = true }

    fun observeData(ip: String, port: Int = 5000): Flow<NetworkResult<ParkingState>> = flow {
        while (true) {
            try {
                emit(NetworkResult.Loading)
                val currentSocket = Socket()
                socket = currentSocket
                
                withContext(Dispatchers.IO) {
                    currentSocket.connect(InetSocketAddress(ip, port), 5000)
                }
                
                mutex.withLock {
                    writer = PrintWriter(currentSocket.getOutputStream(), true)
                }
                
                val reader = BufferedReader(InputStreamReader(currentSocket.getInputStream()))

                // Initial success emission to signal connected state
                emit(NetworkResult.Success(ParkingState(isConnected = true)))

                while (true) {
                    val line = withContext(Dispatchers.IO) { reader.readLine() } ?: break
                    try {
                        val state = json.decodeFromString<ParkingState>(line)
                        emit(NetworkResult.Success(state.copy(isConnected = true)))
                    } catch (e: Exception) {
                        // Skip malformed lines
                    }
                }
            } catch (e: Exception) {
                emit(NetworkResult.Error(e.message ?: "Connection lost"))
            } finally {
                cleanup()
            }
            delay(3000) // Auto-reconnect every 3 seconds
        }
    }.flowOn(Dispatchers.IO)

    suspend fun sendCommand(cmd: String) {
        val jsonCommand = when (cmd) {
            "open_gate_in" -> "{\"cmd\":\"open_gate_in\"}"
            "open_gate_out" -> "{\"cmd\":\"open_gate_out\"}"
            else -> return
        }
        
        mutex.withLock {
            withContext(Dispatchers.IO) {
                try {
                    writer?.println(jsonCommand)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
    }

    private fun cleanup() {
        try {
            writer?.close()
            socket?.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        socket = null
        writer = null
    }

    fun disconnect() {
        cleanup()
    }
}
