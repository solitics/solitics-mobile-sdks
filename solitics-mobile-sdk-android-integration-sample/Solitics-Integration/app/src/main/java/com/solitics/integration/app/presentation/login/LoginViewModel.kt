package com.solitics.integration.app.presentation.login

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.solitics.integration.app.domain.IShowLoginErrorUseCase
import com.solitics.sdk.SoliticsSDK
import com.solitics.sdk.domain.ILoginMetadata
import com.solitics.sdk.domain.exception.LoginFailedException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class LoginViewModel(
        private val launchNextScreen: () -> Unit,
        private val showLoginError: IShowLoginErrorUseCase
) : ViewModel() {

    fun login(loginMetadata: ILoginMetadata) {
        viewModelScope.launch {
            withContext(context = Dispatchers.IO) {

                try {
                    val response = SoliticsSDK.onLogin(loginMetadata)
                    withContext(Dispatchers.Main) {
                        if (response.hashedSubscriberId != 0.toLong()) {
                            launchNextScreen.invoke()
                        } else {
                            throw LoginFailedException("Failed login")
                        }
                    }
                } catch (e: LoginFailedException) {
                    showLoginError.show("Failed, Backend answer: ${e.message}")
                }
            }
        }
    }

    fun onCreate() {
        val currentLoginInfo = SoliticsSDK.currentLoginInfo()
        if (currentLoginInfo.isValid()) {
            launchNextScreen.invoke()
        }
    }
}