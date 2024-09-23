package com.vcinvestmentdiscovery.data.models

import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlinx.serialization.Serializable
import java.util.UUID

@Entity(tableName = "trends")
@Serializable
data class Trend(
    @PrimaryKey val id: UUID,
    val name: String,
    val description: String,
    val category: TrendCategory,
    val identifiedDate: Long,
    var growthRate: Double,
    var confidenceScore: Int,
    val relatedIndustries: List<String>,
    val relatedCompanyIds: List<UUID>,
    val keywords: List<String>,
    var dataId: UUID
) {
    fun isEmergingTrend(emergingThreshold: Double, emergingPeriod: Long): Boolean {
        val currentTime = System.currentTimeMillis()
        val timeDifference = currentTime - identifiedDate
        return growthRate > emergingThreshold && timeDifference <= emergingPeriod
    }

    fun calculateRelevanceScore(): Double {
        // TODO: Implement relevance score calculation with appropriate weights
        val growthRateWeight = 0.4
        val confidenceScoreWeight = 0.3
        val relatedCompaniesWeight = 0.3

        val normalizedGrowthRate = growthRate / 100 // Assuming growth rate is in percentage
        val normalizedConfidenceScore = confidenceScore / 100.0
        val normalizedRelatedCompanies = relatedCompanyIds.size / 10.0 // Assuming 10 is the max number of related companies

        return (normalizedGrowthRate * growthRateWeight) +
               (normalizedConfidenceScore * confidenceScoreWeight) +
               (normalizedRelatedCompanies * relatedCompaniesWeight)
    }

    fun updateTrendData(newDataId: UUID) {
        dataId = newDataId
    }
}