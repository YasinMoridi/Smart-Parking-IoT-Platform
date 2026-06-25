package com.yasin.smartparking.feature.parking.ui

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.Block
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.yasin.smartparking.feature.parking.domain.HistoryEntry
import com.yasin.smartparking.feature.parking.presentation.ParkingViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HistoryScreen(viewModel: ParkingViewModel) {
    val state by viewModel.parkingState.collectAsState()

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { 
                    Text(
                        "HISTORY", 
                        fontWeight = FontWeight.Black,
                        letterSpacing = 2.sp
                    ) 
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color(0xFF0F0F12),
                    titleContentColor = Color.White
                )
            )
        },
        containerColor = Color(0xFF0F0F12)
    ) { paddingValues ->
        if (state.history.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("Empty Logs", color = Color.White, fontSize = 20.sp, fontWeight = FontWeight.Bold)
                    Text("No activity detected yet", color = Color(0xFFB0B0B0), fontSize = 14.sp)
                }
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
                    .padding(horizontal = 20.dp),
                contentPadding = PaddingValues(bottom = 20.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                items(state.history) { entry ->
                    HistoryItem(entry)
                }
            }
        }
    }
}

@Composable
fun HistoryItem(entry: HistoryEntry) {
    val isEnter = entry.event.lowercase() == "enter"
    val isExit = entry.event.lowercase() == "exit"
    
    val (icon, color, label) = when {
        isEnter -> Triple(Icons.Default.ArrowUpward, Color(0xFF00E676), "Vehicle Entered")
        isExit -> Triple(Icons.Default.ArrowDownward, Color(0xFFFF1744), "Vehicle Exited")
        else -> Triple(Icons.Default.Block, Color(0xFFFFAB40), "Entry Denied")
    }

    Surface(
        color = Color(0xFF1C1C23),
        shape = RoundedCornerShape(20.dp),
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Surface(
                color = color.copy(alpha = 0.15f),
                shape = CircleShape,
                modifier = Modifier.size(48.dp)
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Icon(
                        imageVector = icon,
                        contentDescription = null,
                        tint = color,
                        modifier = Modifier.size(24.dp)
                    )
                }
            }
            
            Spacer(modifier = Modifier.width(16.dp))
            
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = label,
                    color = Color.White,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = "Gate Sensor #1",
                    color = Color(0xFFB0B0B0),
                    fontSize = 12.sp
                )
            }
            
            Text(
                text = entry.time,
                color = Color.White,
                fontSize = 14.sp,
                fontWeight = FontWeight.Medium
            )
        }
    }
}
