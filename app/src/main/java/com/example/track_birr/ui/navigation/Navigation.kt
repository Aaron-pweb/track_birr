package com.example.track_birr.ui.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Info
import androidx.compose.ui.graphics.vector.ImageVector

sealed class Screen(val route: String, val title: String, val icon: ImageVector?) {
    object Dashboard : Screen("dashboard", "Dashboard", Icons.Default.Info)
    object Transactions : Screen("transactions", "Transactions", Icons.Default.List)
    object Profile : Screen("profile", "Profile", Icons.Default.Person)
    object AddTransaction : Screen("add_transaction", "Add Transaction", null)
}
