package com.vcinvestmentdiscovery.data.models

import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlinx.serialization.Serializable
import java.util.UUID

@Entity(tableName = "portfolios")
@Serializable
data class Portfolio(
    @PrimaryKey val id: UUID,
    val name: String,
    val creationDate: Long,
    val investmentIds: List<UUID>,
    val totalValue: Double
) {
    fun calculateTotalValue(investments: List<Investment>): Double {
        return investments.sumOf { it.currentValue }
    }

    fun performanceMetrics(investments: List<Investment>): PortfolioMetrics {
        val totalInvestedAmount = investments.sumOf { it.initialAmount }
        val totalCurrentValue = investments.sumOf { it.currentValue }
        val overallROI = (totalCurrentValue - totalInvestedAmount) / totalInvestedAmount * 100

        // TODO: Implement IRR calculation
        val irr = 0.0 // Placeholder for IRR calculation

        return PortfolioMetrics(
            totalInvestedAmount = totalInvestedAmount,
            totalCurrentValue = totalCurrentValue,
            overallROI = overallROI,
            irr = irr
        )
    }
}