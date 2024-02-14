package com.solitics.integration.app

import android.app.Application
import android.util.Log
import com.github.anrwatchdog.ANRError
import com.github.anrwatchdog.ANRWatchDog
import com.google.android.gms.tasks.Task
import com.google.firebase.crashlytics.FirebaseCrashlytics
import com.google.firebase.messaging.FirebaseMessaging
import com.onesignal.OneSignal
import com.onesignal.debug.LogLevel

//const val ONESIGNAL_APP_ID = "24d8f122-544e-4fe0-b6fe-a6f59514df99"
const val ONESIGNAL_APP_ID = "e226f9bf-1893-44b0-b704-e4eff1d2a1fc"

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        startAnrWatchdog()
        logFCMToken()
        setupOneSignal()
    }

    private fun setupOneSignal() {
        OneSignal.Debug.logLevel = LogLevel.VERBOSE
        OneSignal.initWithContext(this, ONESIGNAL_APP_ID)
    }

    private fun startAnrWatchdog() {
        val anrWatchDog = ANRWatchDog()
        if (BuildConfig.LINK_WATCHDOG_TO_CRASHLYTICS) {
            FirebaseCrashlytics.getInstance().setCrashlyticsCollectionEnabled(true)
            anrWatchDog.setReportMainThreadOnly()
            anrWatchDog.setANRListener { error: ANRError ->
                FirebaseCrashlytics.getInstance().recordException(error.fillInStackTrace())
                error.printStackTrace()
            }
        }
        anrWatchDog.start()
    }

    private fun logFCMToken() {
        FirebaseMessaging.getInstance().token
            .addOnCompleteListener { task: Task<String?> ->
                if (task.isSuccessful && task.result != null) {
                    val token = task.result

                    Log.d("FCMToken", token.toString())
                }
            }
    }
}