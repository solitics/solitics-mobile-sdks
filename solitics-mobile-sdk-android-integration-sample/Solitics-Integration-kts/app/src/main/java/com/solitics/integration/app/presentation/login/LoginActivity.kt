package com.solitics.integration.app.presentation.login

import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.ProgressBar
import android.widget.Toast
import android.widget.Toast.LENGTH_SHORT
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import com.solitics.integration.app.R

import com.solitics.sdk.domain.LoginMetadata
import com.solitics.sdk.domain.exception.LoginFailedException

class LoginActivity : AppCompatActivity() {

    private lateinit var loginViewModel: LoginViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_login)

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
        etEmail.setText(R.string.email) // "demo@solitics.com")
        etCustomField.setText(R.string.CustomField) // "{}")
        etBrand.setText(R.string.Brand) // "Fashion")
        etBranch.setText(R.string.Branch) // "bank")
        etKeyType.setText(R.string.KeyType) // "crm")
        etKeyValue.setText(R.string.KeyValue) // "54321098")
        etTokenPupUp.setText(R.string.TokenPupUp) // "Wf9fsDARzdtCqDFJ9cVKrmuF")
        etTxAmount.setText("0")
        etMemberId.setText(R.string.MemberId) // "9910410111064")

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

}

