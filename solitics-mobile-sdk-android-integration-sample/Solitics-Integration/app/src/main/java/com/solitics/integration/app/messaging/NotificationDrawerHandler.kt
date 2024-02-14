package com.solitics.integration.app.messaging

import android.Manifest
import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.ComponentActivity
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.solitics.integration.app.R
import com.solitics.integration.app.presentation.home.HomeActivity

object NotificationDrawerHandler {

    private const val NOTIFICATION_CHANNEL_ID = "SOLITICS_GENERAL_CHANNEL_ID"
    private const val NOTIFICATION_ID = 1212

    @SuppressLint("MissingPermission")
    @JvmStatic
    fun showNotification(context: Context, title: String, body: String) {

        createGeneralNotificationChannelIfNeeded(context)

        val intent = Intent(context, HomeActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            context, 0, intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_CANCEL_CURRENT
        )

        NotificationManagerCompat.from(context)
            .notify(
                NOTIFICATION_ID,
                NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID)
                    .setContentTitle(title)
                    .setContentText(body)
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setSmallIcon(R.drawable.ic_notification)
                    .setContentIntent(pendingIntent)
                    .setAutoCancel(true)
                    .build()
            )
    }

    private fun createGeneralNotificationChannelIfNeeded(context: Context) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && notificationManager.getNotificationChannel(
                NOTIFICATION_CHANNEL_ID
            ) == null) {
            val name = "solitics"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                name,
                importance
            )
            // Register the channel with the system
            notificationManager.createNotificationChannel(channel)
        }
    }


    fun askPermission(activity: ComponentActivity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (activity.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)
                != PackageManager.PERMISSION_GRANTED
            ) {
                activity.registerForActivityResult(
                    ActivityResultContracts.RequestPermission()
                ) {}.launch(Manifest.permission.POST_NOTIFICATIONS)
            }
        }
    }
}
