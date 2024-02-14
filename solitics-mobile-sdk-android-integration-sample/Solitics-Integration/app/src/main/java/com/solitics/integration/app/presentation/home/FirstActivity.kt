package com.solitics.integration.app.presentation.home

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.solitics.integration.app.R
import com.solitics.integration.app.domain.utils.TAG
import com.solitics.integration.app.domain.utils.log
import com.solitics.integration.app.messaging.NotificationDrawerHandler
import com.solitics.sdk.SoliticsSDK

class FirstActivity:  AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_first)

        NotificationDrawerHandler.askPermission(this)
    }
    override fun onResume() {
        super.onResume()
        handleIntent(intent);
    }
    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        Log.d(TAG, "onNewIntent: $intent")

        handleIntent(intent);
    }
    private fun handleIntent(intent: Intent?) {

        if (intent != null && intent.extras != null) {
            for (key in intent.extras!!.keySet()) {
                log("LoginActivity", "key: $key")
                log("LoginActivity", "value: ${intent.extras!!.get(key)}")
            }
        }
        SoliticsSDK.onNewIntent(intent)
    }
}