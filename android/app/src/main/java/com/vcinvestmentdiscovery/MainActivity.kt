package com.vcinvestmentdiscovery

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import androidx.navigation.compose.rememberNavController
import com.vcinvestmentdiscovery.ui.theme.VCInvestmentDiscoveryTheme
import com.vcinvestmentdiscovery.navigation.AppNavHost

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            VCInvestmentDiscoveryTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    val navController = rememberNavController()
                    AppNavHost(navController = navController)
                }
            }
        }
    }
}

// TODO: Implement any necessary permission checks and requests
// TODO: Add initialization for dependency injection (e.g., Hilt)
// TODO: Set up any required system UI flags or window configurations
// TODO: Implement lifecycle-aware components if needed
// TODO: Add error handling and crash reporting initialization