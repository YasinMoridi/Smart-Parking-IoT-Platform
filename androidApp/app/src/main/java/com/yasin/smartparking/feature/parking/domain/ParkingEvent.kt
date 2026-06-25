package com.yasin.smartparking.feature.parking.domain

sealed class ParkingEvent {
    object EnterDetected : ParkingEvent()
    object ExitDetected : ParkingEvent()
    object DeniedDetected : ParkingEvent()
    object ManualOpenIn : ParkingEvent()
    object ManualOpenOut : ParkingEvent()
}
