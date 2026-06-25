package com.yasin.smartparking.feature.parking.presentation

import android.util.Log
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.yasin.smartparking.core.network.NetworkResult
import com.yasin.smartparking.core.network.ParkingSocketClient
import com.yasin.smartparking.feature.parking.data.ParkingRepository
import com.yasin.smartparking.feature.parking.domain.ParkingState
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

sealed class ConnectionState {
    object Disconnected : ConnectionState()
    object Loading : ConnectionState()
    object Connected : ConnectionState()
    data class Error(val message: String) : ConnectionState()
}

class ParkingViewModel(private val savedStateHandle: SavedStateHandle) : ViewModel() {
    private val repository = ParkingRepository(ParkingSocketClient())
    
    private val _parkingState = MutableStateFlow(ParkingState())
    val parkingState: StateFlow<ParkingState> = _parkingState.asStateFlow()
    
    private val _connectionState = MutableStateFlow<ConnectionState>(ConnectionState.Disconnected)
    val connectionState: StateFlow<ConnectionState> = _connectionState.asStateFlow()
    
    private val _snackbarEvent = MutableSharedFlow<String>()
    val snackbarEvent: SharedFlow<String> = _snackbarEvent.asSharedFlow()
    
    private var connectionJob: Job? = null
    
    val savedIp = savedStateHandle.getStateFlow("saved_ip", "")

    fun connect(ip: String) {
        savedStateHandle["saved_ip"] = ip
        connectionJob?.cancel()
        connectionJob = viewModelScope.launch {
            repository.observeParking(ip).collect { result ->
                when (result) {
                    is NetworkResult.Success -> {
                        _connectionState.value = ConnectionState.Connected
                        
                        val oldStatus = _parkingState.value.status
                        val newStatus = result.data.status
                        val newEvent = result.data.event
                        
                        _parkingState.update { currentState ->
                            val occupancy = if (result.data.capacity > 0) {
                                result.data.cars.toFloat() / result.data.capacity.toFloat()
                            } else 0f
                            
                            val newHistory = (currentState.occupancyHistory + occupancy).takeLast(20)
                            
                            result.data.copy(
                                occupancyHistory = newHistory,
                                isConnected = true
                            )
                        }

                        if (newStatus.lowercase() == "full" && oldStatus.lowercase() != "full") {
                            _snackbarEvent.emit("Parking is FULL!")
                        }
                        if (newEvent.lowercase() == "denied") {
                            _snackbarEvent.emit("Entry Denied!")
                        }
                    }
                    is NetworkResult.Error -> {
                        _connectionState.value = ConnectionState.Error(result.message)
                        _parkingState.update { it.copy(isConnected = false) }
                    }
                    NetworkResult.Loading -> {
                        _connectionState.value = ConnectionState.Loading
                    }
                }
            }
        }
    }

    fun disconnect() {
        connectionJob?.cancel()
        repository.disconnect()
        _connectionState.value = ConnectionState.Disconnected
        _parkingState.update { it.copy(isConnected = false) }
    }

    fun openGateIn() {
        viewModelScope.launch { repository.openGateIn() }

    }
    
    fun openGateOut() {
        viewModelScope.launch { repository.openGateOut() }
    }
}
