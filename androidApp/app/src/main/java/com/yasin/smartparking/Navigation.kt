package com.yasin.smartparking

import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.GridView
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.Terminal
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.yasin.smartparking.feature.parking.presentation.ParkingViewModel
import com.yasin.smartparking.feature.parking.ui.ControlScreen
import com.yasin.smartparking.feature.parking.ui.DashboardScreen
import com.yasin.smartparking.feature.parking.ui.HistoryScreen

sealed class Screen(val route: String, val title: String, val icon: ImageVector) {
    object Dashboard : Screen("dashboard", "Dashboard", Icons.Default.GridView)
    object History : Screen("history", "Logs", Icons.Default.History)
    object Control : Screen("control", "Terminal", Icons.Default.Terminal)
}

@Composable
fun AppNavigation(viewModel: ParkingViewModel) {
    val navController = rememberNavController()
    val snackbarHostState = androidx.compose.runtime.remember { SnackbarHostState() }
    val screens = listOf(Screen.Dashboard, Screen.History, Screen.Control)

    Scaffold(
        snackbarHost = { SnackbarHost(snackbarHostState) },
        bottomBar = {
            NavigationBar(
                containerColor = Color(0xFF1C1C23),
                tonalElevation = 0.dp
            ) {
                val navBackStackEntry by navController.currentBackStackEntryAsState()
                val currentDestination = navBackStackEntry?.destination
                
                screens.forEach { screen ->
                    val selected = currentDestination?.hierarchy?.any { it.route == screen.route } == true
                    
                    NavigationBarItem(
                        icon = { 
                            Icon(
                                screen.icon, 
                                contentDescription = null,
                                modifier = Modifier.size(24.dp)
                            ) 
                        },
                        label = { 
                            Text(
                                screen.title,
                                fontSize = 11.sp,
                                fontWeight = if (selected) FontWeight.Bold else FontWeight.Normal
                            ) 
                        },
                        selected = selected,
                        onClick = {
                            navController.navigate(screen.route) {
                                popUpTo(navController.graph.findStartDestination().id) {
                                    saveState = true
                                }
                                launchSingleTop = true
                                restoreState = true
                            }
                        },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = Color.White,
                            selectedTextColor = Color(0xFF7C4DFF),
                            unselectedIconColor = Color(0xFFB0B0B0),
                            unselectedTextColor = Color(0xFFB0B0B0),
                            indicatorColor = Color(0xFF7C4DFF)
                        )
                    )
                }
            }
        }
    ) { innerPadding ->
        NavHost(
            navController = navController,
            startDestination = Screen.Dashboard.route,
            modifier = Modifier.padding(innerPadding)
        ) {
            composable(Screen.Dashboard.route) {
                DashboardScreen(viewModel, snackbarHostState)
            }
            composable(Screen.History.route) {
                HistoryScreen(viewModel)
            }
            composable(Screen.Control.route) {
                ControlScreen(viewModel)
            }
        }
    }
}
