package com.solitics.integration.app

import android.app.Application
import com.github.anrwatchdog.ANRError
import com.github.anrwatchdog.ANRWatchDog
import com.google.firebase.crashlytics.FirebaseCrashlytics

class App : Application() {

    override fun onCreate() {
        super.onCreate()
        startAnrWatchdog()
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
}

