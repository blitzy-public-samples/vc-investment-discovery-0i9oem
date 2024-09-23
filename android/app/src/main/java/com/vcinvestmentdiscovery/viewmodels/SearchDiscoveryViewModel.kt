package com.vcinvestmentdiscovery.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import com.vcinvestmentdiscovery.data.repository.SearchRepository
import com.vcinvestmentdiscovery.data.models.*
import com.vcinvestmentdiscovery.util.Result
import com.vcinvestmentdiscovery.ui.search.SearchDiscoveryUiState

@HiltViewModel
class SearchDiscoveryViewModel @Inject constructor(
    private val repository: SearchRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(SearchDiscoveryUiState())
    val uiState: StateFlow<SearchDiscoveryUiState> = _uiState.asStateFlow()

    fun performSearch() {
        _uiState.value = _uiState.value.copy(isLoading = true)
        viewModelScope.launch {
            when (val result = repository.search(
                _uiState.value.searchQuery,
                _uiState.value.selectedFilters,
                _uiState.value.sortOption
            )) {
                is Result.Success -> {
                    _uiState.value = _uiState.value.copy(
                        searchResults = result.data,
                        isLoading = false,
                        error = null
                    )
                }
                is Result.Error -> {
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        error = result.exception.message
                    )
                }
            }
        }
    }

    fun updateSearchQuery(query: String) {
        _uiState.value = _uiState.value.copy(searchQuery = query)
        performSearch()
    }

    fun updateFilters(filters: Set<SearchFilter>) {
        _uiState.value = _uiState.value.copy(selectedFilters = filters)
        performSearch()
    }

    fun updateSortOption(option: SortOption) {
        _uiState.value = _uiState.value.copy(sortOption = option)
        performSearch()
    }

    fun loadMoreResults() {
        _uiState.value = _uiState.value.copy(isLoading = true)
        viewModelScope.launch {
            when (val result = repository.loadMoreSearchResults()) {
                is Result.Success -> {
                    _uiState.value = _uiState.value.copy(
                        searchResults = _uiState.value.searchResults + result.data,
                        isLoading = false,
                        error = null
                    )
                }
                is Result.Error -> {
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        error = result.exception.message
                    )
                }
            }
        }
    }

    suspend fun getSuggestions(): List<String> {
        return repository.getSearchSuggestions(_uiState.value.searchQuery)
    }
}