package com.solitics.integration.app.presentation.login

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.ProgressBar
import android.widget.Toast
import android.widget.Toast.LENGTH_SHORT
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import com.solitics.integration.app.R
import com.solitics.integration.app.domain.utils.TAG
import com.solitics.integration.app.domain.utils.log
import com.solitics.integration.app.logger.FileLogger
import com.solitics.integration.app.messaging.NotificationDrawerHandler
import com.solitics.sdk.SoliticsSDK
import com.solitics.sdk.domain.LoginMetadata
import com.solitics.sdk.domain.exception.LoginFailedException

class LoginActivity : AppCompatActivity() {

    private lateinit var loginViewModel: LoginViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        // handleIntent(intent)

        log(message = "Log Files:\n${FileLogger.readLogFile(this)}")
        FileLogger.deleteFileContent(this)
        log(message = "fileLogger cleared")
        NotificationDrawerHandler.askPermission(this)

        val etEmail = findViewById<EditText>(R.id.etEmail)
        val etCustomField = findViewById<EditText>(R.id.etCustomFields)
        val etBrand = findViewById<EditText>(R.id.etBrand)
        val etKeyType = findViewById<EditText>(R.id.etKeyType)
        val etKeyValue = findViewById<EditText>(R.id.etKeyValue)
        val etTokenPupUp = findViewById<EditText>(R.id.etTokenPopUp)
        val etTxAmount = findViewById<EditText>(R.id.etTxAmount)
        val etMemberId = findViewById<EditText>(R.id.etMemberId)
        val etBranch = findViewById<EditText>(R.id.etBranch)

        val btnLogin = findViewById<Button>(R.id.bntLogin)
        val loading = findViewById<ProgressBar>(R.id.loading)

        // Just for internal testing
        etEmail.setText(getString(R.string.email))
        etKeyType.setText(getString(R.string.KeyType))
        etKeyValue.setText(getString(R.string.KeyValue))
        etTokenPupUp.setText(getString(R.string.TokenPupUp))
        etMemberId.setText(getString(R.string.MemberId))

        etCustomField.setText(getString(R.string.CustomField))
        etBrand.setText(getString(R.string.Brand))
        etBranch.setText(getString(R.string.Branch))

        etTxAmount.setText("0")


        loginViewModel = ViewModelProvider(this, LoginViewModelFactory(this))[LoginViewModel::class.java]

        btnLogin.setOnClickListener {
            loading.visibility = View.VISIBLE
            val loginInfo = LoginMetadata(
                txAmount = if (etTxAmount.text.toString().isEmpty()
                ) 0 else etTxAmount.text.toString().toInt(),
                memberId = etMemberId.text.toString(),
                popupToken = etTokenPupUp.text.toString()
            )

            if (etEmail.text.toString().isNotBlank()) {
                loginInfo.email = etEmail.text.toString()
            }
            if (etCustomField.text.toString().isNotBlank()) {
                loginInfo.customFields = etCustomField.text.toString()
            }
            if (etKeyValue.text.toString().isNotBlank()) {
                loginInfo.keyValue = etKeyValue.text.toString()
            }
            if (etKeyType.text.toString().isNotBlank()) {
                loginInfo.keyType = etKeyType.text.toString()
            }
            if (etBrand.text.toString().isNotBlank()) {
                loginInfo.brand = etBrand.text.toString()
            }
            if (etBranch.text.toString().isNotBlank()) {
                loginInfo.branch = etBranch.text.toString()
            }

            try {
                loginViewModel.login(loginInfo)
            } catch (e: LoginFailedException) {
                Toast.makeText(applicationContext, "Failed login", LENGTH_SHORT).show()
                e.printStackTrace()
            } finally {
                loading.visibility = View.GONE
            }
        }

        loginViewModel.onCreate()
    }

    override fun onResume() {
        super.onResume()
        handleIntent(intent);
    }
    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        Log.d(TAG, "onNewIntent: $intent")

        handleIntent(intent)
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

