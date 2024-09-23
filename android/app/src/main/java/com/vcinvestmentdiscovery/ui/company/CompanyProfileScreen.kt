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
fun CompanyProfileScreen(navController: NavController, companyId: String) {
    val viewModel: CompanyProfileViewModel = hiltViewModel()
    val state = viewModel.state.collectAsState()

    VCInvestmentDiscoveryTheme {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("Company Profile") },
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
                    .padding(paddingValues)
                    .fillMaxSize()
                    .padding(16.dp)
            ) {
                state.value.company?.let { company ->
                    CompanyOverviewSection(company)
                    Spacer(modifier = Modifier.height(16.dp))
                    FinancialDataSection(state.value.financialData)
                    Spacer(modifier = Modifier.height(16.dp))
                    SocialMetricsSection(state.value.socialData)
                    Spacer(modifier = Modifier.height(16.dp))
                    InvestmentPerformanceSection(state.value.investmentPerformance)
                }
            }
        }
    }
}

@Composable
fun CompanyOverviewSection(company: Company) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            // TODO: Add company logo
            Text(text = company.name, style = MaterialTheme.typography.headlineMedium)
            Text(text = company.industry, style = MaterialTheme.typography.bodyLarge)
            Spacer(modifier = Modifier.height(8.dp))
            Text("Founded: ${company.foundingDate}")
            Text("Headquarters: ${company.headquarters}")
            Text("CEO: ${company.ceo}")
            Spacer(modifier = Modifier.height(8.dp))
            Text(company.description, style = MaterialTheme.typography.bodyMedium)
        }
    }
}

@Composable
fun FinancialDataSection(financialData: FinancialData) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("Financial Data", style = MaterialTheme.typography.headlineSmall)
            Spacer(modifier = Modifier.height(8.dp))
            Text("Revenue: $${financialData.revenue}")
            Text("Profit: $${financialData.profit}")
            Text("Burn Rate: $${financialData.burnRate}/month")
            // TODO: Add charts for financial trends
            // TODO: Add industry benchmark comparison
        }
    }
}

@Composable
fun SocialMetricsSection(socialData: SocialData) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("Social Metrics", style = MaterialTheme.typography.headlineSmall)
            Spacer(modifier = Modifier.height(8.dp))
            Text("Twitter Followers: ${socialData.twitterFollowers}")
            Text("LinkedIn Followers: ${socialData.linkedInFollowers}")
            Text("Web Traffic: ${socialData.webTraffic} visits/month")
            Text("Sentiment Score: ${socialData.sentimentScore}")
            // TODO: Add market sentiment analysis visualization
            // TODO: Add web traffic and app download trends
        }
    }
}

@Composable
fun InvestmentPerformanceSection(performance: InvestmentPerformance) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("Investment Performance", style = MaterialTheme.typography.headlineSmall)
            Spacer(modifier = Modifier.height(8.dp))
            Text("Initial Investment: $${performance.initialInvestment}")
            Text("Current Valuation: $${performance.currentValuation}")
            Text("ROI: ${performance.roi}%")
            Text("IRR: ${performance.irr}%")
            // TODO: Add chart showing investment value over time
        }
    }
}