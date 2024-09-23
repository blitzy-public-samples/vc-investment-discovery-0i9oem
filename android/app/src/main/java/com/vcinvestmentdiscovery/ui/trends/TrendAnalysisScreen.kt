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
fun TrendAnalysisScreen(navController: NavController) {
    val viewModel: TrendAnalysisViewModel = hiltViewModel()
    val state = viewModel.state.collectAsState()

    VCInvestmentDiscoveryTheme {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("Trend Analysis") },
                    navigationIcon = {
                        IconButton(onClick = { navController.navigateUp() }) {
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
                    .padding(16.dp)
            ) {
                TrendingSectorsSection(
                    sectors = state.value.trendingSectors,
                    onSectorClick = viewModel::onSectorClick
                )
                Spacer(modifier = Modifier.height(16.dp))
                EmergingTechnologiesSection(
                    technologies = state.value.emergingTechnologies,
                    onTechnologyClick = viewModel::onTechnologyClick
                )
                Spacer(modifier = Modifier.height(16.dp))
                MarketSentimentSection(sentiment = state.value.marketSentiment)
                Spacer(modifier = Modifier.height(16.dp))
                PredictiveAnalyticsSection(analytics = state.value.predictiveAnalytics)
            }
        }
    }
}

@Composable
fun TrendingSectorsSection(
    sectors: List<TrendingSector>,
    onSectorClick: (TrendingSector) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("Trending Sectors", style = MaterialTheme.typography.h6)
            Spacer(modifier = Modifier.height(8.dp))
            LazyColumn {
                items(sectors) { sector ->
                    TrendingSectorItem(sector = sector, onClick = { onSectorClick(sector) })
                }
            }
            // TODO: Add chart or graph to visualize sector performance
        }
    }
}

@Composable
fun EmergingTechnologiesSection(
    technologies: List<EmergingTechnology>,
    onTechnologyClick: (EmergingTechnology) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("Emerging Technologies", style = MaterialTheme.typography.h6)
            Spacer(modifier = Modifier.height(8.dp))
            LazyColumn {
                items(technologies) { technology ->
                    EmergingTechnologyItem(technology = technology, onClick = { onTechnologyClick(technology) })
                }
            }
            // TODO: Add links to related startups or companies
        }
    }
}

@Composable
fun MarketSentimentSection(sentiment: MarketSentiment) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("Market Sentiment", style = MaterialTheme.typography.h6)
            Spacer(modifier = Modifier.height(8.dp))
            // Display overall market sentiment indicators
            Text("Overall Sentiment: ${sentiment.overallSentiment}")
            // Show sentiment trends for specific sectors or technologies
            // TODO: Add visualization of social media and news sentiment analysis
        }
    }
}

@Composable
fun PredictiveAnalyticsSection(analytics: PredictiveAnalytics) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text("Predictive Analytics", style = MaterialTheme.typography.h6)
            Spacer(modifier = Modifier.height(8.dp))
            // Display AI-driven predictions for market trends
            Text("Market Trend Prediction: ${analytics.marketTrendPrediction}")
            // Show forecasted growth rates for sectors and technologies
            // TODO: Add confidence intervals and scenario analysis visualizations
        }
    }
}