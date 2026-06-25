package com.yasin.smartparking.feature.parking.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Lan
import androidx.compose.material.icons.filled.LockOpen
import androidx.compose.material.icons.filled.MeetingRoom
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.yasin.smartparking.feature.parking.presentation.ConnectionState
import com.yasin.smartparking.feature.parking.presentation.ParkingViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ControlScreen(viewModel: ParkingViewModel) {
    val parkingState by viewModel.parkingState.collectAsState()
    val connectionState by viewModel.connectionState.collectAsState()
    val savedIp by viewModel.savedIp.collectAsState()
    
    var ipInput by remember(savedIp) { mutableStateOf(savedIp.ifEmpty { "192.168.1.100" }) }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { 
                    Text(
                        "TERMINAL", 
                        fontWeight = FontWeight.Black,
                        letterSpacing = 2.sp
                    ) 
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = Color(0xFF0F0F12),
                    titleContentColor = Color.White
                )
            )
        },
        containerColor = Color(0xFF0F0F12)
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(24.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            // Configuration Card
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(28.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFF1C1C23))
            ) {
                Column(modifier = Modifier.padding(20.dp)) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.Lan, contentDescription = null, tint = Color(0xFF7C4DFF))
                        Spacer(modifier = Modifier.width(12.dp))
                        Text("Server Configuration", color = Color.White, fontWeight = FontWeight.Bold)
                    }
                    
                    Spacer(modifier = Modifier.height(20.dp))
                    
                    OutlinedTextField(
                        value = ipInput,
                        onValueChange = { ipInput = it },
                        label = { Text("Gateway IP", color = Color(0xFFB0B0B0)) },
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(16.dp),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedTextColor = Color.White,
                            unfocusedTextColor = Color.White,
                            focusedBorderColor = Color(0xFF7C4DFF),
                            unfocusedBorderColor = Color(0xFF32323D),
                            focusedContainerColor = Color(0xFF0F0F12),
                            unfocusedContainerColor = Color(0xFF0F0F12)
                        )
                    )

                    Spacer(modifier = Modifier.height(16.dp))

                    val isConnected = connectionState is ConnectionState.Connected
                    val isLoading = connectionState is ConnectionState.Loading

                    Button(
                        onClick = {
                            if (isConnected || isLoading) viewModel.disconnect()
                            else viewModel.connect(ipInput)
                        },
                        modifier = Modifier.fillMaxWidth().height(56.dp),
                        shape = RoundedCornerShape(16.dp),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = if (isConnected || isLoading) Color(0xFFFF1744) else Color(0xFF7C4DFF)
                        )
                    ) {
                        if (isLoading) {
                            CircularProgressIndicator(color = Color.White, modifier = Modifier.size(24.dp))
                        } else {
                            Text(
                                if (isConnected) "TERMINATE CONNECTION" else "INITIALIZE CONNECTION",
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }
                    
                    if (connectionState is ConnectionState.Error) {
                        Text(
                            text = (connectionState as ConnectionState.Error).message,
                            color = Color(0xFFFF1744),
                            fontSize = 12.sp,
                            modifier = Modifier.padding(top = 8.dp)
                        )
                    }
                }
            }

            // Gate Control Section
            Text(
                "Manual Overrides",
                color = Color.White,
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold
            )

            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                GateButton(
                    modifier = Modifier.weight(1f),
                    label = "Entry Gate",
                    icon = Icons.Default.LockOpen,
                    enabled = parkingState.isConnected,
                    onClick = { viewModel.openGateIn() }
                )
                GateButton(
                    modifier = Modifier.weight(1f),
                    label = "Exit Gate",
                    icon = Icons.Default.MeetingRoom,
                    enabled = parkingState.isConnected,
                    onClick = { viewModel.openGateOut() }
                )
            }

            Spacer(modifier = Modifier.weight(1f))

            // Warning
            Surface(
                color = Color(0xFFFF1744).copy(alpha = 0.1f),
                shape = RoundedCornerShape(16.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    modifier = Modifier.padding(16.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("⚠️", fontSize = 20.sp)
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(
                        "Manual gate control is active. Use only in emergency situations.",
                        color = Color(0xFFFF1744),
                        fontSize = 12.sp,
                        lineHeight = 16.sp
                    )
                }
            }
        }
    }
}

@Composable
fun GateButton(
    modifier: Modifier = Modifier,
    label: String,
    icon: ImageVector,
    enabled: Boolean,
    onClick: () -> Unit
) {
    Surface(
        onClick = onClick,
        enabled = enabled,
        modifier = modifier.height(120.dp),
        shape = RoundedCornerShape(24.dp),
        color = if (enabled) Color(0xFF1C1C23) else Color(0xFF1C1C23).copy(alpha = 0.5f),
        border = if (enabled) BorderStroke(1.dp, Color(0xFF32323D)) else null
    ) {
        Column(
            modifier = Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = if (enabled) Color(0xFF7C4DFF) else Color(0xFFB0B0B0),
                modifier = Modifier.size(32.dp)
            )
            Spacer(modifier = Modifier.height(12.dp))
            Text(
                text = label,
                color = if (enabled) Color.White else Color(0xFFB0B0B0),
                fontWeight = FontWeight.Bold,
                fontSize = 14.sp
            )
        }
    }
}
