package com.solitics.integration.app.messaging

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.solitics.integration.app.logger.FileLogger

class NotificationsService : FirebaseMessagingService() {
    override fun onMessageReceived(p0: RemoteMessage) {

        val data = p0.data
        val title = p0.notification?.title ?: "no title"
        val body = p0.notification?.body ?: "no body"

        val log = buildString {
            append("$TAG\n")
            append("onMessageReceived\n")
            append("remoteMessage: $p0\n")
            append("data: $data\n")
            append("title: $title\n")
            append("body: $body")
        }

        logToFile(log)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            ActivityCompat.checkSelfPermission(
                this, Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }

        // NotificationDrawerHandler.showNotification(this, title, body)
    }

    override fun onNewToken(p0: String) {
        super.onNewToken(p0)

        logToFile("onNewToken: $p0")
    }

    override fun onMessageSent(p0: String) {
        super.onMessageSent(p0)

        logToFile("onMessageSent: $p0")
    }

    companion object {
        const val TAG = "MessagingService"
    }

    private fun logToFile(message: String) {
        FileLogger.log(this, TAG, message)
        FileLogger.log(this, TAG, "-------------------------------------")
    }
}