package com.yasin.smartparking.feature.parking.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.yasin.smartparking.feature.parking.presentation.ParkingViewModel
import com.yasin.smartparking.feature.parking.ui.components.OccupancyChart
import com.yasin.smartparking.feature.parking.ui.components.StatusCard
import kotlinx.coroutines.flow.collectLatest

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DashboardScreen(
    viewModel: ParkingViewModel,
    snackbarHostState: SnackbarHostState
) {
    val state by viewModel.parkingState.collectAsState()
    val scrollState = rememberScrollState()

    LaunchedEffect(Unit) {
        viewModel.snackbarEvent.collectLatest { message ->
            snackbarHostState.showSnackbar(message)
        }
    }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { 
                    Text(
                        "IOT PARKING", 
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Black,
                        letterSpacing = 2.sp
                    ) 
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color(0xFF0F0F12),
                    titleContentColor = Color.White
                ),
                actions = {
                    IconButton(onClick = { }) {
                        Icon(Icons.Default.Notifications, contentDescription = null, tint = Color.White)
                    }
                }
            )
        },
        containerColor = Color(0xFF0F0F12)
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(scrollState)
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            // Connection Status Bar
            Surface(
                color = Color(0xFF1C1C23),
                shape = RoundedCornerShape(16.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    modifier = Modifier.padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(
                        modifier = Modifier
                            .size(10.dp)
                            .background(
                                if (state.isConnected) Color(0xFF00E676) else Color(0xFFFF1744),
                                shape = CircleShape
                            )
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(
                        text = if (state.isConnected) "System Online" else "System Offline",
                        color = Color.White,
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Medium
                    )
                }
            }

            StatusCard(
                status = state.status,
                cars = state.cars,
                capacity = state.capacity,
                available = state.available
            )

            // Chart Section
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(28.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFF1C1C23))
            ) {
                Column(modifier = Modifier.padding(20.dp)) {
                    Text(
                        "Live Occupancy",
                        color = Color.White,
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold
                    )
                    Text(
                        "Last 20 updates",
                        color = Color(0xFFB0B0B0),
                        fontSize = 12.sp
                    )
                    Spacer(modifier = Modifier.height(24.dp))
                    OccupancyChart(
                        data = state.occupancyHistory
                    )
                }
            }

            if (state.history.isNotEmpty()) {
                val lastEvent = state.history.first()
                Text(
                    "Recent Activity",
                    color = Color.White,
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold
                )
                
                Surface(
                    onClick = {},
                    color = Color(0xFF1C1C23),
                    shape = RoundedCornerShape(20.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Surface(
                            color = Color(0xFF7C4DFF).copy(alpha = 0.2f),
                            shape = CircleShape,
                            modifier = Modifier.size(40.dp)
                        ) {
                            Box(contentAlignment = Alignment.Center) {
                                Text("⚡", fontSize = 16.sp)
                            }
                        }
                        Spacer(modifier = Modifier.width(16.dp))
                        Column {
                            Text(
                                "Car ${lastEvent.event.replaceFirstChar { it.uppercase() }}",
                                color = Color.White,
                                fontWeight = FontWeight.SemiBold
                            )
                            Text(
                                lastEvent.time,
                                color = Color(0xFFB0B0B0),
                                fontSize = 12.sp
                            )
                        }
                    }
                }
            }
        }
    }
}
