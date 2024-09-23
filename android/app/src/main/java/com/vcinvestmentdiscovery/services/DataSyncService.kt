package com.vcinvestmentdiscovery.services

import javax.inject.Inject
import javax.inject.Singleton
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.withContext
import com.vcinvestmentdiscovery.data.repository.LocalRepository
import com.vcinvestmentdiscovery.data.repository.RemoteRepository
import com.vcinvestmentdiscovery.util.Result
import com.vcinvestmentdiscovery.util.NetworkUtils
import androidx.work.*

@Singleton
class DataSyncService @Inject constructor(
    private val localRepository: LocalRepository,
    private val remoteRepository: RemoteRepository,
    private val networkUtils: NetworkUtils
) {

    private val _isSyncing = MutableStateFlow(false)
    val isSyncing: StateFlow<Boolean> = _isSyncing.asStateFlow()

    suspend fun syncData(): Result<Unit> = withContext(Dispatchers.IO) {
        if (!networkUtils.isNetworkAvailable()) {
            return@withContext Result.Error("No network connection")
        }

        _isSyncing.value = true

        try {
            val localChanges = localRepository.getLocalChanges()
            remoteRepository.sendLocalChanges(localChanges)

            val remoteChanges = remoteRepository.getRemoteChanges()
            val resolvedData = resolveConflicts(localChanges, remoteChanges)

            localRepository.applyRemoteChanges(resolvedData)

            _isSyncing.value = false
            Result.Success(Unit)
        } catch (e: Exception) {
            _isSyncing.value = false
            Result.Error("Sync failed: ${e.message}")
        }
    }

    fun schedulePeriodicSync(intervalMillis: Long) {
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        val syncWorkRequest = PeriodicWorkRequestBuilder<SyncWorker>(intervalMillis)
            .setConstraints(constraints)
            .build()

        WorkManager.getInstance().enqueueUniquePeriodicWork(
            "periodicSync",
            ExistingPeriodicWorkPolicy.REPLACE,
            syncWorkRequest
        )
    }

    fun cancelPeriodicSync() {
        WorkManager.getInstance().cancelUniqueWork("periodicSync")
    }

    private fun resolveConflicts(localData: Map<String, Any>, remoteData: Map<String, Any>): Map<String, Any> {
        val resolvedData = mutableMapOf<String, Any>()

        for (key in localData.keys.union(remoteData.keys)) {
            when {
                key in localData && key in remoteData -> {
                    // Conflict resolution strategy: Latest wins
                    // TODO: Implement a more sophisticated conflict resolution strategy
                    resolvedData[key] = remoteData[key] ?: localData[key]!!
                }
                key in localData -> resolvedData[key] = localData[key]!!
                key in remoteData -> resolvedData[key] = remoteData[key]!!
            }
        }

        return resolvedData
    }

    class SyncWorker(
        context: Context,
        params: WorkerParameters
    ) : CoroutineWorker(context, params) {

        @Inject
        lateinit var dataSyncService: DataSyncService

        override suspend fun doWork(): Result {
            return when (dataSyncService.syncData()) {
                is Result.Success -> Result.success()
                is Result.Error -> Result.retry()
            }
        }
    }
}