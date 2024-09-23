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
fun PortfolioScreen(navController: NavController) {
    val viewModel: PortfolioViewModel = hiltViewModel()
    val state = viewModel.state.collectAsState().value

    VCInvestmentDiscoveryTheme {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("Portfolio") },
                    navigationIcon = {
                        IconButton(onClick = { navController.popBackStack() }) {
                            Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                        }
                    }
                )
            }
        ) { paddingValues ->
            Column(
                modifier = Modifier
                    .padding(paddingValues)
                    .fillMaxSize()
                    .padding(16.dp)
            ) {
                when {
                    state.isLoading -> {
                        CircularProgressIndicator(modifier = Modifier.align(Alignment.CenterHorizontally))
                    }
                    state.error != null -> {
                        Text(
                            text = "Error: ${state.error}",
                            color = MaterialTheme.colorScheme.error,
                            modifier = Modifier.align(Alignment.CenterHorizontally)
                        )
                    }
                    else -> {
                        PortfolioSummarySection(summary = state.portfolioSummary)
                        Spacer(modifier = Modifier.height(16.dp))
                        AssetAllocationSection(allocation = state.assetAllocation)
                        Spacer(modifier = Modifier.height(16.dp))
                        InvestmentListSection(
                            investments = state.investments,
                            onInvestmentClick = { investment ->
                                navController.navigate("investment/${investment.id}")
                            }
                        )
                        Spacer(modifier = Modifier.height(16.dp))
                        PerformanceMetricsSection(metrics = state.performanceMetrics)
                    }
                }
            }
        }
    }
}

@Composable
fun PortfolioSummarySection(summary: PortfolioSummary) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(
                text = "Total Portfolio Value",
                style = MaterialTheme.typography.headlineSmall
            )
            Text(
                text = "$${summary.totalValue}",
                style = MaterialTheme.typography.headlineMedium
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Total Return: ${summary.totalReturn}%",
                style = MaterialTheme.typography.bodyMedium
            )
            Text(
                text = "IRR: ${summary.irr}%",
                style = MaterialTheme.typography.bodyMedium
            )
            // TODO: Add chart showing portfolio value over time
        }
    }
}

@Composable
fun AssetAllocationSection(allocation: AssetAllocation) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(
                text = "Asset Allocation",
                style = MaterialTheme.typography.headlineSmall
            )
            // TODO: Add pie chart showing allocation by sector or stage
            // TODO: Display legend with allocation percentages
        }
    }
}

@Composable
fun InvestmentListSection(
    investments: List<Investment>,
    onInvestmentClick: (Investment) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(
                text = "Investments",
                style = MaterialTheme.typography.headlineSmall
            )
            LazyColumn {
                items(investments) { investment ->
                    InvestmentItem(
                        investment = investment,
                        onClick = { onInvestmentClick(investment) }
                    )
                }
            }
        }
    }
}

@Composable
fun InvestmentItem(investment: Investment, onClick: () -> Unit) {
    Surface(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick),
        color = MaterialTheme.colorScheme.surface
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Column {
                Text(text = investment.companyName, style = MaterialTheme.typography.bodyLarge)
                Text(text = "Invested: $${investment.investedAmount}", style = MaterialTheme.typography.bodyMedium)
            }
            Column(horizontalAlignment = Alignment.End) {
                Text(text = "Current: $${investment.currentValue}", style = MaterialTheme.typography.bodyMedium)
                Text(
                    text = "Return: ${investment.returnPercentage}%",
                    style = MaterialTheme.typography.bodyMedium,
                    color = if (investment.returnPercentage >= 0) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.error
                )
            }
        }
    }
}

@Composable
fun PerformanceMetricsSection(metrics: PerformanceMetrics) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(
                text = "Performance Metrics",
                style = MaterialTheme.typography.headlineSmall
            )
            Text(text = "TVPI: ${metrics.tvpi}", style = MaterialTheme.typography.bodyMedium)
            Text(text = "DPI: ${metrics.dpi}", style = MaterialTheme.typography.bodyMedium)
            Text(text = "RVPI: ${metrics.rvpi}", style = MaterialTheme.typography.bodyMedium)
            // TODO: Add chart showing performance over time
        }
    }
}