package com.vcinvestmentdiscovery.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import com.vcinvestmentdiscovery.data.repository.DashboardRepository
import com.vcinvestmentdiscovery.data.models.*
import com.vcinvestmentdiscovery.util.Result
import com.vcinvestmentdiscovery.ui.dashboard.DashboardUiState
import java.util.UUID

@HiltViewModel
class DashboardViewModel @Inject constructor(
    private val repository: DashboardRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(DashboardUiState())
    val uiState: StateFlow<DashboardUiState> = _uiState.asStateFlow()

    init {
        loadDashboardData()
    }

    fun loadDashboardData() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true)

            val portfolioOverviewResult = repository.getPortfolioOverview()
            val recentAlertsResult = repository.getRecentAlerts()
            val trendingInvestmentsResult = repository.getTrendingInvestments()

            _uiState.value = _uiState.value.copy(
                isLoading = false,
                portfolioOverview = (portfolioOverviewResult as? Result.Success)?.data,
                recentAlerts = (recentAlertsResult as? Result.Success)?.data ?: emptyList(),
                trendingInvestments = (trendingInvestmentsResult as? Result.Success)?.data ?: emptyList(),
                error = when {
                    portfolioOverviewResult is Result.Error -> portfolioOverviewResult.exception.message
                    recentAlertsResult is Result.Error -> recentAlertsResult.exception.message
                    trendingInvestmentsResult is Result.Error -> trendingInvestmentsResult.exception.message
                    else -> null
                }
            )
        }
    }

    fun refreshDashboard() {
        loadDashboardData()
    }

    fun markAlertAsRead(alertId: UUID) {
        viewModelScope.launch {
            val result = repository.markAlertAsRead(alertId)
            if (result is Result.Success) {
                _uiState.value = _uiState.value.copy(
                    recentAlerts = _uiState.value.recentAlerts.filter { it.id != alertId }
                )
            } else if (result is Result.Error) {
                _uiState.value = _uiState.value.copy(error = result.exception.message)
            }
        }
    }

    fun loadMoreTrendingInvestments() {
        viewModelScope.launch {
            val result = repository.getMoreTrendingInvestments()
            if (result is Result.Success) {
                _uiState.value = _uiState.value.copy(
                    trendingInvestments = _uiState.value.trendingInvestments + result.data
                )
            } else if (result is Result.Error) {
                _uiState.value = _uiState.value.copy(error = result.exception.message)
            }
        }
    }
}