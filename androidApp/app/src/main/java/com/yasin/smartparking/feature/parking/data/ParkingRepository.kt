package com.yasin.smartparking.feature.parking.data

import com.yasin.smartparking.core.network.NetworkResult
import com.yasin.smartparking.core.network.ParkingSocketClient
import com.yasin.smartparking.feature.parking.domain.ParkingState
import kotlinx.coroutines.flow.Flow

class ParkingRepository(private val client: ParkingSocketClient) {
    fun observeParking(ip: String): Flow<NetworkResult<ParkingState>> = client.observeData(ip)
    
    suspend fun openGateIn() = client.sendCommand("open_gate_in")
    
    suspend fun openGateOut() = client.sendCommand("open_gate_out")
    
    fun disconnect() = client.disconnect()
}
