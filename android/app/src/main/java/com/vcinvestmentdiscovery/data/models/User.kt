package com.vcinvestmentdiscovery.data.models

import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlinx.serialization.Serializable
import java.util.UUID

@Entity(tableName = "users")
@Serializable
data class User(
    @PrimaryKey val id: UUID,
    val email: String,
    val firstName: String,
    val lastName: String,
    val dateJoined: Long,
    val preferences: UserPreferences,
    val portfolioIds: List<UUID>
) {
    fun fullName(): String {
        return "$firstName $lastName"
    }
}

// TODO: Implement data validation for user properties (e.g., email format)
// TODO: Add methods for updating user information
// TODO: Create unit tests for the User data class
// TODO: Implement type converters for Room database if needed (e.g., for UUID and UserPreferences)
// TODO: Consider adding additional user-related properties or methods as per app requirements