package com.vcinvestmentdiscovery.services

import javax.inject.Inject
import javax.inject.Singleton
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import com.vcinvestmentdiscovery.data.repository.UserRepository
import com.vcinvestmentdiscovery.data.models.User
import com.vcinvestmentdiscovery.util.Result
import com.vcinvestmentdiscovery.util.PreferenceManager

@Singleton
class AuthenticationService @Inject constructor() {

    @Inject
    lateinit var userRepository: UserRepository

    @Inject
    lateinit var preferenceManager: PreferenceManager

    private var currentUser: User? = null

    suspend fun signIn(email: String, password: String): Result<User> = withContext(Dispatchers.IO) {
        try {
            val result = userRepository.signIn(email, password)
            if (result is Result.Success) {
                preferenceManager.saveAuthToken(result.data.token)
                currentUser = result.data
            }
            result
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    suspend fun signUp(email: String, password: String, firstName: String, lastName: String): Result<User> = withContext(Dispatchers.IO) {
        try {
            val result = userRepository.signUp(email, password, firstName, lastName)
            if (result is Result.Success) {
                preferenceManager.saveAuthToken(result.data.token)
                currentUser = result.data
            }
            result
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    suspend fun signOut(): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            userRepository.signOut()
            preferenceManager.removeAuthToken()
            currentUser = null
            Result.Success(Unit)
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    suspend fun refreshToken(): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            val currentToken = preferenceManager.getAuthToken()
            val result = userRepository.refreshToken(currentToken)
            if (result is Result.Success) {
                preferenceManager.saveAuthToken(result.data)
            }
            Result.Success(Unit)
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    fun getCurrentUser(): User? {
        return currentUser
    }

    fun isAuthenticated(): Boolean {
        return currentUser != null && preferenceManager.getAuthToken() != null
    }
}