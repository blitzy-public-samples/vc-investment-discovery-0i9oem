package com.vcinvestmentdiscovery.services

import javax.inject.Inject
import javax.inject.Singleton
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.vcinvestmentdiscovery.data.repository.NotificationRepository
import com.vcinvestmentdiscovery.data.models.Notification
import com.vcinvestmentdiscovery.util.Result
import com.vcinvestmentdiscovery.util.PreferenceManager

@Singleton
class NotificationService @Inject constructor(
    private val notificationRepository: NotificationRepository,
    private val preferenceManager: PreferenceManager,
    private val context: android.content.Context
) : FirebaseMessagingService() {

    private val notificationManager: NotificationManagerCompat = NotificationManagerCompat.from(context)

    override fun onNewToken(token: String) {
        preferenceManager.saveDeviceToken(token)
        notificationRepository.updateDeviceToken(token)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        remoteMessage.notification?.let { firebaseNotification ->
            val notification = Notification(
                id = remoteMessage.messageId ?: "",
                title = firebaseNotification.title ?: "",
                body = firebaseNotification.body ?: "",
                type = remoteMessage.data["type"] ?: "",
                timestamp = System.currentTimeMillis()
            )
            handleReceivedNotification(notification)
        }
    }

    private fun handleReceivedNotification(notification: Notification) {
        notificationRepository.saveNotification(notification)
        showNotification(notification)
        notificationRepository.markNotificationAsReceived(notification.id)
    }

    private fun showNotification(notification: Notification) {
        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(notification.title)
            .setContentText(notification.body)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setAutoCancel(true)

        val intent = createIntentForNotification(notification)
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        builder.setContentIntent(pendingIntent)

        notificationManager.notify(notification.id.hashCode(), builder.build())
    }

    fun cancelNotification(notificationId: Int) {
        notificationManager.cancel(notificationId)
        notificationRepository.markNotificationAsCancelled(notificationId.toString())
    }

    suspend fun updateNotificationSettings(settings: NotificationSettings): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            preferenceManager.saveNotificationSettings(settings)
            notificationRepository.updateNotificationSettings(settings)
            Result.Success(Unit)
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    private fun createIntentForNotification(notification: Notification): Intent {
        // TODO: Implement deep linking based on notification type
        return Intent(this, MainActivity::class.java)
    }

    companion object {
        private const val CHANNEL_ID = "vc_investment_discovery_channel"
    }
}