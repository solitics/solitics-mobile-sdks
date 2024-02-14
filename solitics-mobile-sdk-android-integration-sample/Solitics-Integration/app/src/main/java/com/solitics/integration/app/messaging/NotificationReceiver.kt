package com.solitics.integration.app.messaging

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.google.firebase.messaging.RemoteMessage
import com.solitics.integration.app.logger.FileLogger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob

class NotificationReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "NotificationReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action

        FileLogger.apply {
            log(context, TAG, TAG)
            log(context, TAG, "onReceive")
            log(context, TAG, action)
        }

        if (action != null && action == "com.google.android.c2dm.intent.RECEIVE") {

            val bundle = intent.extras
            if (bundle != null) {

                val remoteMessage = RemoteMessage(bundle)
                val body = remoteMessage.notification?.body
                val title = remoteMessage.notification?.title

                FileLogger.apply {
                    log(context, TAG, "From: ${remoteMessage.from}")
                    log(context, TAG, "Body: $body")
                    log(context, TAG, "Title: $title")
                    log(context, TAG, "data: ${remoteMessage.data}")
                }
            }
        }
    }
}