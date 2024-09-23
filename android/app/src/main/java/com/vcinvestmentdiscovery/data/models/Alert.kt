package com.vcinvestmentdiscovery.data.models

import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlinx.serialization.Serializable
import java.util.UUID

@Entity(tableName = "alerts")
@Serializable
data class Alert(
    @PrimaryKey val id: UUID,
    val userId: UUID,
    val type: AlertType,
    val title: String,
    val message: String,
    val createdAt: Long,
    var isRead: Boolean = false,
    val relatedEntityId: UUID? = null,
    val priority: AlertPriority
) {
    fun markAsRead() {
        isRead = true
    }

    fun isExpired(expirationInterval: Long): Boolean {
        val currentTime = System.currentTimeMillis()
        val timeDifference = currentTime - createdAt
        return timeDifference > expirationInterval
    }
}