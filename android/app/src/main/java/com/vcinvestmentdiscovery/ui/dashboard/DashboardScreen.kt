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
fun DashboardScreen(navController: NavController) {
    val viewModel: DashboardViewModel = hiltViewModel()
    val state = viewModel.state.collectAsState()

    VCInvestmentDiscoveryTheme {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("Dashboard") }
                )
            }
        ) { paddingValues ->
            Column(
                modifier = Modifier
                    .padding(paddingValues)
                    .fillMaxSize()
            ) {
                Spacer(modifier = Modifier.height(16.dp))
                
                PortfolioOverviewSection(
                    portfolioOverview = state.value.portfolioOverview,
                    onViewPortfolioClick = { navController.navigate("portfolio") }
                )
                
                Spacer(modifier = Modifier.height(16.dp))
                
                RecentAlertsSection(
                    alerts = state.value.recentAlerts,
                    onAlertClick = { alert -> navController.navigate("alert/${alert.id}") }
                )
                
                Spacer(modifier = Modifier.height(16.dp))
                
                TrendingInvestmentsSection(
                    trendingInvestments = state.value.trendingInvestments,
                    onInvestmentClick = { investment -> navController.navigate("investment/${investment.id}") }
                )
                
                Spacer(modifier = Modifier.height(16.dp))
                
                QuickActionsSection(
                    onNewInvestmentClick = { navController.navigate("new_investment") },
                    onSearchClick = { navController.navigate("search") },
                    onReportsClick = { navController.navigate("reports") }
                )
            }
        }
    }
}

@Composable
fun PortfolioOverviewSection(portfolioOverview: PortfolioOverview, onViewPortfolioClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "Total Portfolio Value",
                style = MaterialTheme.typography.headlineSmall
            )
            Text(
                text = "$${portfolioOverview.totalValue}",
                style = MaterialTheme.typography.headlineMedium
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Daily Change: ${portfolioOverview.dailyChange}%",
                style = MaterialTheme.typography.bodyMedium
            )
            Text(
                text = "Total Return: ${portfolioOverview.totalReturn}%",
                style = MaterialTheme.typography.bodyMedium
            )
            Spacer(modifier = Modifier.height(16.dp))
            Button(onClick = onViewPortfolioClick) {
                Text("View Full Portfolio")
            }
        }
    }
}

@Composable
fun RecentAlertsSection(alerts: List<Alert>, onAlertClick: (Alert) -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "Recent Alerts",
                style = MaterialTheme.typography.headlineSmall
            )
            Spacer(modifier = Modifier.height(8.dp))
            LazyColumn {
                items(alerts) { alert ->
                    AlertItem(alert = alert, onClick = { onAlertClick(alert) })
                }
            }
        }
    }
}

@Composable
fun TrendingInvestmentsSection(trendingInvestments: List<TrendingInvestment>, onInvestmentClick: (TrendingInvestment) -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "Trending Investments",
                style = MaterialTheme.typography.headlineSmall
            )
            Spacer(modifier = Modifier.height(8.dp))
            LazyRow {
                items(trendingInvestments) { investment ->
                    TrendingInvestmentItem(investment = investment, onClick = { onInvestmentClick(investment) })
                }
            }
        }
    }
}

@Composable
fun QuickActionsSection(onNewInvestmentClick: () -> Unit, onSearchClick: () -> Unit, onReportsClick: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        horizontalArrangement = Spacer.Between
    ) {
        Button(onClick = onNewInvestmentClick) {
            Text("New Investment")
        }
        Button(onClick = onSearchClick) {
            Text("Search")
        }
        Button(onClick = onReportsClick) {
            Text("Reports")
        }
    }
}