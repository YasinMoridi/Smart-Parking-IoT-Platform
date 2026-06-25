package com.yasin.smartparking.feature.parking.ui.components

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun StatusCard(
    status: String,
    cars: Int,
    capacity: Int,
    available: Int
) {
    val isFull = status.lowercase() == "full"
    val accentColor by animateColorAsState(
        if (isFull) Color(0xFFFF1744) else Color(0xFF00E676),
        label = "color"
    )
    
    val progress by animateFloatAsState(
        targetValue = cars.toFloat() / capacity.toFloat(),
        label = "progress"
    )

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .height(220.dp),
        shape = RoundedCornerShape(28.dp),
        border = BorderStroke(1.dp, Color(0xFF32323D)),
        colors = CardDefaults.cardColors(containerColor = Color(0xFF1C1C23))
    ) {
        Box(modifier = Modifier.fillMaxSize()) {
            // Gradient Glow Background
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(
                        Brush.radialGradient(
                            colors = listOf(accentColor.copy(alpha = 0.15f), Color.Transparent),
                            center = androidx.compose.ui.geometry.Offset(700f, 0f),
                            radius = 600f
                        )
                    )
            )

            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(24.dp),
                verticalArrangement = Arrangement.SpaceBetween
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.Top
                ) {
                    Column {
                        Text(
                            text = if (isFull) "Parking Full" else "Spaces Available",
                            color = Color.White,
                            fontSize = 24.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = "Smart IoT Monitor",
                            color = Color(0xFFB0B0B0),
                            fontSize = 14.sp
                        )
                    }
                    
                    Surface(
                        color = accentColor.copy(alpha = 0.2f),
                        shape = RoundedCornerShape(12.dp),
                        border = BorderStroke(1.dp, accentColor.copy(alpha = 0.5f))
                    ) {
                        Text(
                            text = status.uppercase(),
                            modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
                            color = accentColor,
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.Bottom,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Column {
                        Text(
                            text = "$cars",
                            color = Color.White,
                            fontSize = 48.sp,
                            fontWeight = FontWeight.Black
                        )
                        Text(
                            text = "Occupied",
                            color = Color(0xFFB0B0B0),
                            fontSize = 14.sp
                        )
                    }
                    
                    Column(horizontalAlignment = Alignment.End) {
                        Text(
                            text = "$available",
                            color = accentColor,
                            fontSize = 32.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = "Free Spots",
                            color = Color(0xFFB0B0B0),
                            fontSize = 14.sp
                        )
                    }
                }

                LinearProgressIndicator(
                    progress = { progress },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(12.dp),
                    color = accentColor,
                    trackColor = Color(0xFF0F0F12),
                    strokeCap = androidx.compose.ui.graphics.StrokeCap.Round
                )
            }
        }
    }
}
