package com.vcinvestmentdiscovery.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import com.vcinvestmentdiscovery.data.repository.PortfolioRepository
import com.vcinvestmentdiscovery.data.models.*
import com.vcinvestmentdiscovery.util.Result
import java.util.UUID
import com.vcinvestmentdiscovery.ui.portfolio.PortfolioUiState

@HiltViewModel
class PortfolioViewModel @Inject constructor(
    private val repository: PortfolioRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(PortfolioUiState())
    val uiState: StateFlow<PortfolioUiState> = _uiState.asStateFlow()

    fun loadPortfolio(portfolioId: UUID) {
        _uiState.value = _uiState.value.copy(isLoading = true)
        viewModelScope.launch {
            try {
                val portfolio = repository.getPortfolio(portfolioId)
                val assetAllocation = repository.getAssetAllocation(portfolioId)
                val performanceMetrics = repository.getPerformanceMetrics(portfolioId)
                
                _uiState.value = PortfolioUiState(
                    portfolio = portfolio,
                    assetAllocation = assetAllocation,
                    performanceMetrics = performanceMetrics,
                    isLoading = false
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = e.message ?: "An error occurred while loading the portfolio"
                )
            }
        }
    }

    fun refreshPortfolio() {
        _uiState.value.portfolio?.id?.let { portfolioId ->
            loadPortfolio(portfolioId)
        }
    }

    fun addInvestment(investment: Investment) {
        viewModelScope.launch {
            try {
                val result = repository.addInvestment(investment)
                if (result is Result.Success) {
                    val updatedPortfolio = _uiState.value.portfolio?.copy(
                        investments = _uiState.value.portfolio.investments + investment
                    )
                    _uiState.value = _uiState.value.copy(
                        portfolio = updatedPortfolio,
                        assetAllocation = recalculateAssetAllocation(updatedPortfolio),
                        performanceMetrics = recalculatePerformanceMetrics(updatedPortfolio)
                    )
                } else if (result is Result.Error) {
                    _uiState.value = _uiState.value.copy(error = result.exception.message)
                }
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(error = e.message ?: "Failed to add investment")
            }
        }
    }

    fun removeInvestment(investmentId: UUID) {
        viewModelScope.launch {
            try {
                val result = repository.removeInvestment(investmentId)
                if (result is Result.Success) {
                    val updatedPortfolio = _uiState.value.portfolio?.copy(
                        investments = _uiState.value.portfolio.investments.filter { it.id != investmentId }
                    )
                    _uiState.value = _uiState.value.copy(
                        portfolio = updatedPortfolio,
                        assetAllocation = recalculateAssetAllocation(updatedPortfolio),
                        performanceMetrics = recalculatePerformanceMetrics(updatedPortfolio)
                    )
                } else if (result is Result.Error) {
                    _uiState.value = _uiState.value.copy(error = result.exception.message)
                }
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(error = e.message ?: "Failed to remove investment")
            }
        }
    }

    fun updateInvestment(updatedInvestment: Investment) {
        viewModelScope.launch {
            try {
                val result = repository.updateInvestment(updatedInvestment)
                if (result is Result.Success) {
                    val updatedPortfolio = _uiState.value.portfolio?.copy(
                        investments = _uiState.value.portfolio.investments.map { 
                            if (it.id == updatedInvestment.id) updatedInvestment else it 
                        }
                    )
                    _uiState.value = _uiState.value.copy(
                        portfolio = updatedPortfolio,
                        assetAllocation = recalculateAssetAllocation(updatedPortfolio),
                        performanceMetrics = recalculatePerformanceMetrics(updatedPortfolio)
                    )
                } else if (result is Result.Error) {
                    _uiState.value = _uiState.value.copy(error = result.exception.message)
                }
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(error = e.message ?: "Failed to update investment")
            }
        }
    }

    private fun recalculateAssetAllocation(portfolio: Portfolio?): AssetAllocation {
        // Implement asset allocation recalculation logic
        // This is a placeholder and should be replaced with actual logic
        return AssetAllocation()
    }

    private fun recalculatePerformanceMetrics(portfolio: Portfolio?): PerformanceMetrics {
        // Implement performance metrics recalculation logic
        // This is a placeholder and should be replaced with actual logic
        return PerformanceMetrics()
    }
}