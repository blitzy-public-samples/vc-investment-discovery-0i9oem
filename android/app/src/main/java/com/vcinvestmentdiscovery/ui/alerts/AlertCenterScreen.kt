import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.vcinvestmentdiscovery.ui.components.*
import com.vcinvestmentdiscovery.ui.theme.VCInvestmentDiscoveryTheme

@Composable
fun AlertCenterScreen(navController: NavController) {
    val viewModel: AlertCenterViewModel = hiltViewModel()
    val uiState = viewModel.uiState.collectAsState()

    VCInvestmentDiscoveryTheme {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("Alert Center") },
                    navigationIcon = {
                        IconButton(onClick = { navController.popBackStack() }) {
                            Icon(Icons.Filled.ArrowBack, contentDescription = "Back")
                        }
                    }
                )
            }
        ) { paddingValues ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
            ) {
                AlertFilterSection(
                    currentFilter = uiState.value.currentFilter,
                    onFilterChange = { viewModel.updateFilter(it) }
                )
                
                Spacer(modifier = Modifier.height(16.dp))
                
                AlertListSection(
                    alerts = uiState.value.filteredAlerts,
                    onAlertClick = { viewModel.onAlertClicked(it) },
                    onAlertDismiss = { viewModel.dismissAlert(it) }
                )
            }
        }
    }
}

@Composable
fun AlertFilterSection(
    currentFilter: AlertFilter,
    onFilterChange: (AlertFilter) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp)
    ) {
        FilterChip(
            selected = currentFilter.type == AlertType.ALL,
            onClick = { onFilterChange(currentFilter.copy(type = AlertType.ALL)) },
            label = { Text("All") }
        )
        Spacer(modifier = Modifier.width(8.dp))
        FilterChip(
            selected = currentFilter.type == AlertType.UNREAD,
            onClick = { onFilterChange(currentFilter.copy(type = AlertType.UNREAD)) },
            label = { Text("Unread") }
        )
        // Add more filter chips for priority levels and date range
    }
}

@Composable
fun AlertListSection(
    alerts: List<Alert>,
    onAlertClick: (Alert) -> Unit,
    onAlertDismiss: (Alert) -> Unit
) {
    LazyColumn {
        items(alerts) { alert ->
            AlertItem(
                alert = alert,
                onClick = { onAlertClick(alert) },
                onDismiss = { onAlertDismiss(alert) }
            )
        }
    }
}

@Composable
fun AlertItem(
    alert: Alert,
    onClick: () -> Unit,
    onDismiss: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp)
            .clickable(onClick = onClick)
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth()
        ) {
            // Add icon or color indicator based on alert type and priority
            Column(modifier = Modifier.weight(1f)) {
                Text(text = alert.title, style = MaterialTheme.typography.titleMedium)
                Text(text = alert.message, style = MaterialTheme.typography.bodyMedium)
                Text(text = formatDate(alert.timestamp), style = MaterialTheme.typography.bodySmall)
            }
            IconButton(onClick = onDismiss) {
                Icon(Icons.Filled.Close, contentDescription = "Dismiss")
            }
        }
    }
}