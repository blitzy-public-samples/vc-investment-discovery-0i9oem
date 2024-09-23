package com.vcinvestmentdiscovery.data.models

import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlinx.serialization.Serializable
import java.util.UUID

@Entity(tableName = "investments")
@Serializable
data class Investment(
    @PrimaryKey val id: UUID,
    val companyId: UUID,
    val investmentDate: Long,
    val initialAmount: Double,
    var currentValue: Double,
    val stage: InvestmentStage,
    val ownershipPercentage: Double,
    val transactionIds: List<UUID>
) {
    fun updateCurrentValue(newValue: Double) {
        currentValue = newValue
    }

    fun calculateROI(): Double {
        val gain = currentValue - initialAmount
        return (gain / initialAmount) * 100
    }

    fun calculateIRR(transactions: List<Transaction>): Double {
        // TODO: Implement IRR calculation algorithm
        // This is a placeholder implementation
        return 0.0
    }
}

// TODO: Implement data validation
// TODO: Add methods for adding and updating transactions
// TODO: Create unit tests
// TODO: Implement type converters for Room if needed
// TODO: Consider adding additional investment-related properties or methods
// TODO: Implement a method to generate an investment summary or report