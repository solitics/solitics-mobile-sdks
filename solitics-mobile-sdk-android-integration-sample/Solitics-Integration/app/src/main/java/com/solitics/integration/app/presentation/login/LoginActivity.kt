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
import com.solitics.sdk.domain.LoginFailedException
import com.solitics.sdk.domain.LoginMetadata

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
        etEmail.setText("demo@solitics.com")
        etCustomField.setText("{}")
        etBrand.setText("Fashion")
        etBranch.setText("bank")
        etKeyType.setText("crm")
        etKeyValue.setText("54321098")
        etTokenPupUp.setText("Wf9fsDARzdtCqDFJ9cVKrmuF")
        etTxAmount.setText("0")
        etMemberId.setText("9910410111064")

        loginViewModel = ViewModelProvider(this, LoginViewModelFactory(this))
            .get(LoginViewModel::class.java)

        btnLogin.setOnClickListener {
            loading.visibility = View.VISIBLE
            val loginInfo = LoginMetadata(
                txAmount = if (etTxAmount.text.toString().isEmpty()
                ) 0 else etTxAmount.text.toString().toInt(),
                memberId = etMemberId.text.toString(),
                popupToken = etTokenPupUp.text.toString()
            )

            if (!etEmail.text.toString().isBlank()) {
                loginInfo.email = etEmail.text.toString()
            }
            if (!etCustomField.text.toString().isBlank()) {
                loginInfo.customFields = etCustomField.text.toString()
            }
            if (!etKeyValue.text.toString().isBlank()) {
                loginInfo.keyValue = etKeyValue.text.toString()
            }
            if (!etKeyType.text.toString().isBlank()) {
                loginInfo.keyType = etKeyType.text.toString()
            }
            if (!etBrand.text.toString().isBlank()) {
                loginInfo.brand = etBrand.text.toString()
            }
            if (!etBranch.text.toString().isBlank()) {
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

