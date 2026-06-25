package com.yasin.smartparking

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.lifecycle.viewmodel.compose.viewModel
import com.yasin.smartparking.feature.parking.presentation.ParkingViewModel
import com.yasin.smartparking.ui.theme.SmartParkingTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            SmartParkingTheme {
                val viewModel: ParkingViewModel = viewModel()
                AppNavigation(viewModel)
            }
        }
    }
}
