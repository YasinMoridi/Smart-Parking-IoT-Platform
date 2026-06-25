package com.yasin.smartparking.feature.parking.domain

import kotlinx.serialization.Serializable

@Serializable
data class ParkingState(
    val cars: Int = 0,
    val capacity: Int = 10,
    val available: Int = 10,
    val status: String = "available",
    val event: String = "none",
    val history: List<HistoryEntry> = emptyList(),
    val occupancyHistory: List<Float> = emptyList(),
    val isConnected: Boolean = false
)

@Serializable
data class HistoryEntry(
    val time: String,
    val event: String
)
