package com.vcinvestmentdiscovery.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import com.vcinvestmentdiscovery.data.repository.CompanyRepository
import com.vcinvestmentdiscovery.data.models.*
import com.vcinvestmentdiscovery.util.Result
import java.util.UUID

@HiltViewModel
class CompanyProfileViewModel @Inject constructor(
    private val repository: CompanyRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(CompanyProfileUiState())
    val uiState: StateFlow<CompanyProfileUiState> = _uiState.asStateFlow()

    fun loadCompanyProfile(companyId: UUID) {
        _uiState.value = _uiState.value.copy(isLoading = true)
        viewModelScope.launch {
            try {
                val company = repository.getCompany(companyId)
                val financialData = repository.getFinancialData(companyId)
                val socialData = repository.getSocialData(companyId)
                val marketData = repository.getMarketData(companyId)
                val relatedTrends = repository.getRelatedTrends(companyId)

                _uiState.value = CompanyProfileUiState(
                    company = company,
                    financialData = financialData,
                    socialData = socialData,
                    marketData = marketData,
                    relatedTrends = relatedTrends,
                    isLoading = false
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = e.message ?: "An error occurred while loading the company profile"
                )
            }
        }
    }

    fun refreshCompanyProfile() {
        uiState.value.company?.id?.let { companyId ->
            loadCompanyProfile(companyId)
        }
    }

    fun updateFinancialData(newData: FinancialData) {
        viewModelScope.launch {
            try {
                val result = repository.updateFinancialData(newData)
                if (result is Result.Success) {
                    _uiState.value = _uiState.value.copy(financialData = newData)
                } else {
                    _uiState.value = _uiState.value.copy(
                        error = (result as Result.Error).message
                    )
                }
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    error = e.message ?: "An error occurred while updating financial data"
                )
            }
        }
    }

    fun updateSocialData(newData: SocialData) {
        viewModelScope.launch {
            try {
                val result = repository.updateSocialData(newData)
                if (result is Result.Success) {
                    _uiState.value = _uiState.value.copy(socialData = newData)
                } else {
                    _uiState.value = _uiState.value.copy(
                        error = (result as Result.Error).message
                    )
                }
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    error = e.message ?: "An error occurred while updating social data"
                )
            }
        }
    }

    fun updateMarketData(newData: MarketData) {
        viewModelScope.launch {
            try {
                val result = repository.updateMarketData(newData)
                if (result is Result.Success) {
                    _uiState.value = _uiState.value.copy(marketData = newData)
                } else {
                    _uiState.value = _uiState.value.copy(
                        error = (result as Result.Error).message
                    )
                }
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    error = e.message ?: "An error occurred while updating market data"
                )
            }
        }
    }

    fun calculateInvestmentPotential(): Double {
        val financialData = _uiState.value.financialData
        val socialData = _uiState.value.socialData
        val marketData = _uiState.value.marketData

        // TODO: Implement a sophisticated algorithm for calculating investment potential
        // This is a placeholder implementation and should be refined with domain experts
        val financialScore = financialData?.let { (it.revenue + it.profit) / it.valuation } ?: 0.0
        val socialScore = socialData?.let { (it.followers + it.engagement) / 1000.0 } ?: 0.0
        val marketScore = marketData?.let { it.marketShare * it.growthRate } ?: 0.0

        return (financialScore * 0.5 + socialScore * 0.3 + marketScore * 0.2) * 100
    }
}