package com.vcinvestmentdiscovery.data.models

import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlinx.serialization.Serializable
import java.util.UUID

@Entity(tableName = "companies")
@Serializable
data class Company(
    @PrimaryKey val id: UUID,
    val name: String,
    val industry: String,
    val foundingDate: Long,
    val description: String,
    val headquarters: String,
    val website: String?,
    var valuation: Double,
    var employeeCount: Int,
    val founders: List<String>,
    var stage: CompanyStage,
    val fundingRoundIds: List<UUID>,
    var financialDataId: UUID?,
    var socialDataId: UUID?,
    var marketDataId: UUID?
) {
    fun totalFundingRaised(fundingRounds: List<FundingRound>): Double {
        return fundingRounds.sumOf { it.amount }
    }

    fun latestValuation(): Double {
        return valuation
    }

    fun updateFinancialData(newDataId: UUID) {
        financialDataId = newDataId
    }

    fun updateSocialData(newDataId: UUID) {
        socialDataId = newDataId
    }

    fun updateMarketData(newDataId: UUID) {
        marketDataId = newDataId
    }
}