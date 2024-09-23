package com.vcinvestmentdiscovery.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import com.vcinvestmentdiscovery.data.repository.AlertRepository
import com.vcinvestmentdiscovery.data.models.*
import com.vcinvestmentdiscovery.util.Result
import com.vcinvestmentdiscovery.ui.alerts.AlertCenterUiState
import java.util.UUID

@HiltViewModel
class AlertCenterViewModel @Inject constructor(
    private val repository: AlertRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(AlertCenterUiState())
    val uiState: StateFlow<AlertCenterUiState> = _uiState.asStateFlow()

    init {
        loadAlerts()
    }

    fun loadAlerts() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true)
            when (val result = repository.getAlerts()) {
                is Result.Success -> {
                    _uiState.value = _uiState.value.copy(
                        alerts = result.data,
                        filteredAlerts = applyFilter(result.data, _uiState.value.selectedFilter),
                        isLoading = false
                    )
                }
                is Result.Error -> {
                    _uiState.value = _uiState.value.copy(
                        error = result.exception.message ?: "Unknown error occurred",
                        isLoading = false
                    )
                }
            }
        }
    }

    fun refreshAlerts() {
        loadAlerts()
    }

    fun markAlertAsRead(alertId: UUID) {
        viewModelScope.launch {
            when (val result = repository.markAlertAsRead(alertId)) {
                is Result.Success -> {
                    val updatedAlerts = _uiState.value.alerts.map { alert ->
                        if (alert.id == alertId) alert.copy(isRead = true) else alert
                    }
                    _uiState.value = _uiState.value.copy(
                        alerts = updatedAlerts,
                        filteredAlerts = applyFilter(updatedAlerts, _uiState.value.selectedFilter)
                    )
                }
                is Result.Error -> {
                    _uiState.value = _uiState.value.copy(
                        error = result.exception.message ?: "Failed to mark alert as read"
                    )
                }
            }
        }
    }

    fun deleteAlert(alertId: UUID) {
        viewModelScope.launch {
            when (val result = repository.deleteAlert(alertId)) {
                is Result.Success -> {
                    val updatedAlerts = _uiState.value.alerts.filter { it.id != alertId }
                    _uiState.value = _uiState.value.copy(
                        alerts = updatedAlerts,
                        filteredAlerts = applyFilter(updatedAlerts, _uiState.value.selectedFilter)
                    )
                }
                is Result.Error -> {
                    _uiState.value = _uiState.value.copy(
                        error = result.exception.message ?: "Failed to delete alert"
                    )
                }
            }
        }
    }

    fun applyFilter(filter: AlertFilter) {
        _uiState.value = _uiState.value.copy(
            selectedFilter = filter,
            filteredAlerts = applyFilter(_uiState.value.alerts, filter)
        )
    }

    fun sortAlerts(criteria: AlertSortCriteria) {
        val sortedAlerts = when (criteria) {
            AlertSortCriteria.DATE_DESC -> _uiState.value.filteredAlerts.sortedByDescending { it.createdAt }
            AlertSortCriteria.DATE_ASC -> _uiState.value.filteredAlerts.sortedBy { it.createdAt }
            AlertSortCriteria.PRIORITY_DESC -> _uiState.value.filteredAlerts.sortedByDescending { it.priority }
            AlertSortCriteria.PRIORITY_ASC -> _uiState.value.filteredAlerts.sortedBy { it.priority }
        }
        _uiState.value = _uiState.value.copy(filteredAlerts = sortedAlerts)
    }

    private fun applyFilter(alerts: List<Alert>, filter: AlertFilter): List<Alert> {
        return alerts.filter { alert ->
            (filter.type == null || alert.type == filter.type) &&
            (filter.priority == null || alert.priority == filter.priority) &&
            (filter.isRead == null || alert.isRead == filter.isRead)
        }
    }
}