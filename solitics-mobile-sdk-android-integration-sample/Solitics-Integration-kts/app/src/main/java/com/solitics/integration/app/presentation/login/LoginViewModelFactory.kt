package com.solitics.integration.app.presentation.login

import android.app.Activity
import android.content.Intent
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.google.android.material.snackbar.BaseTransientBottomBar.LENGTH_LONG
import com.google.android.material.snackbar.Snackbar
import com.solitics.integration.app.R
import com.solitics.integration.app.domain.IShowLoginErrorUseCase
import com.solitics.integration.app.presentation.home.HomeActivity

/**
 * ViewModel provider factory to instantiate LoginViewModel.
 * Required given LoginViewModel has a non-empty constructor
 */
class LoginViewModelFactory(
    private val activity: Activity,
) : ViewModelProvider.Factory {

    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(LoginViewModel::class.java)) {
            return LoginViewModel(
                launchNextScreen = {
                    activity.startActivity(Intent(activity, HomeActivity::class.java)
                        .also {
                            it.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        })
                },
                showLoginError = object : IShowLoginErrorUseCase {
                    override fun show(text: String) {
                        Snackbar.make(activity.findViewById(R.id.container), text, LENGTH_LONG)
                            .show()

                    }
                }
            ) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}