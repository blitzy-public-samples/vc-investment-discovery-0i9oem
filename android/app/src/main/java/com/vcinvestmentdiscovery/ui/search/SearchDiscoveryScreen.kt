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
fun SearchDiscoveryScreen(navController: NavController) {
    val viewModel: SearchDiscoveryViewModel = hiltViewModel()
    val state = viewModel.uiState.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Search & Discovery") },
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
        ) {
            SearchBar(
                query = state.value.searchQuery,
                onQueryChange = { viewModel.updateSearchQuery(it) }
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            FilterSection(
                filters = state.value.selectedFilters,
                onFilterChange = { viewModel.updateFilters(it) }
            )
            
            Spacer(modifier = Modifier.height(16.dp))
            
            SearchResultsList(
                results = state.value.searchResults,
                onResultClick = { result -> 
                    // Navigate to result details
                    navController.navigate("resultDetails/${result.id}")
                }
            )
        }
    }
}

@Composable
fun SearchBar(query: String, onQueryChange: (String) -> Unit) {
    TextField(
        value = query,
        onValueChange = onQueryChange,
        modifier = Modifier.fillMaxWidth(),
        placeholder = { Text("Search investments...") },
        leadingIcon = { Icon(Icons.Filled.Search, contentDescription = null) },
        trailingIcon = {
            if (query.isNotEmpty()) {
                IconButton(onClick = { onQueryChange("") }) {
                    Icon(Icons.Filled.Clear, contentDescription = "Clear")
                }
            }
        }
    )
}

@Composable
fun FilterSection(filters: SearchFilters, onFilterChange: (SearchFilters) -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .horizontalScroll(rememberScrollState())
    ) {
        FilterChip(
            selected = filters.industry != null,
            onClick = { /* Open industry filter dialog */ },
            label = { Text("Industry") }
        )
        Spacer(modifier = Modifier.width(8.dp))
        FilterChip(
            selected = filters.stage != null,
            onClick = { /* Open stage filter dialog */ },
            label = { Text("Stage") }
        )
        Spacer(modifier = Modifier.width(8.dp))
        FilterChip(
            selected = filters.location != null,
            onClick = { /* Open location filter dialog */ },
            label = { Text("Location") }
        )
        Spacer(modifier = Modifier.width(8.dp))
        Button(onClick = { /* Open advanced filters dialog */ }) {
            Text("Advanced Filters")
        }
    }
}

@Composable
fun SearchResultsList(results: List<SearchResult>, onResultClick: (SearchResult) -> Unit) {
    LazyColumn {
        items(results) { result ->
            SearchResultItem(result = result, onClick = { onResultClick(result) })
        }
        item {
            if (results.isNotEmpty()) {
                CircularProgressIndicator(modifier = Modifier.fillMaxWidth().padding(16.dp))
            }
        }
    }
}

@Composable
fun SearchResultItem(result: SearchResult, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .clickable(onClick = onClick)
    ) {
        Row(modifier = Modifier.padding(16.dp)) {
            // Add an icon or image based on result type
            Icon(
                imageVector = when (result.type) {
                    ResultType.COMPANY -> Icons.Filled.Business
                    ResultType.INVESTMENT -> Icons.Filled.MonetizationOn
                    ResultType.TREND -> Icons.Filled.TrendingUp
                },
                contentDescription = null
            )
            Spacer(modifier = Modifier.width(16.dp))
            Column {
                Text(text = result.title, style = MaterialTheme.typography.titleMedium)
                Text(text = result.description, style = MaterialTheme.typography.bodyMedium)
                Text(
                    text = when (result.type) {
                        ResultType.COMPANY -> "Valuation: ${result.metrics["valuation"]}"
                        ResultType.INVESTMENT -> "ROI: ${result.metrics["roi"]}"
                        ResultType.TREND -> "Growth Rate: ${result.metrics["growthRate"]}"
                    },
                    style = MaterialTheme.typography.bodySmall
                )
            }
        }
    }
}