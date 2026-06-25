package com.yasin.smartparking.feature.parking.ui.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.unit.dp

@Composable
fun OccupancyChart(
    data: List<Float>
) {
    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(180.dp)
    ) {
        if (data.size < 2) return@Canvas

        val width = size.width
        val height = size.height
        val spacing = width / (data.size - 1)

        val path = Path()
        val fillPath = Path()
        
        data.forEachIndexed { index, occupancy ->
            // occupancy is 0.0 to 1.0
            val x = index * spacing
            val y = height - (occupancy * height)
            
            if (index == 0) {
                path.moveTo(x, y)
                fillPath.moveTo(x, height)
                fillPath.lineTo(x, y)
            } else {
                val prevX = (index - 1) * spacing
                val prevY = height - (data[index - 1] * height)
                path.cubicTo(
                    (prevX + x) / 2, prevY,
                    (prevX + x) / 2, y,
                    x, y
                )
                fillPath.cubicTo(
                    (prevX + x) / 2, prevY,
                    (prevX + x) / 2, y,
                    x, y
                )
            }
            
            if (index == data.size - 1) {
                fillPath.lineTo(x, height)
                fillPath.close()
            }
        }

        drawPath(
            path = fillPath,
            brush = Brush.verticalGradient(
                colors = listOf(Color(0xFF7C4DFF).copy(alpha = 0.3f), Color.Transparent)
            )
        )

        drawPath(
            path = path,
            color = Color(0xFF7C4DFF),
            style = Stroke(width = 4.dp.toPx(), cap = androidx.compose.ui.graphics.StrokeCap.Round)
        )
        
        val gridLines = 4
        for (i in 0..gridLines) {
            val y = height - (i * height / gridLines)
            drawLine(
                color = Color.White.copy(alpha = 0.05f),
                start = androidx.compose.ui.geometry.Offset(0f, y),
                end = androidx.compose.ui.geometry.Offset(width, y),
                strokeWidth = 1.dp.toPx()
            )
        }
    }
}
