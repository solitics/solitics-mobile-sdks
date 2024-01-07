package com.solitics.integration.app.presentation.home

import android.content.Context
import android.content.Intent
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.solitics.integration.app.presentation.login.LoginActivity
import com.solitics.integration.app.repo.SharedPrefCustomEmitEventParamsRepo

class HomeViewModelFactory(
    private val context: Context
) : ViewModelProvider.Factory {

    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(HomeViewModel::class.java)) {
            return HomeViewModel(
                resetToLoginScreen = {
                    context.startActivity(Intent(context, LoginActivity::class.java).also {
                        it.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    })
                },
                customEmitEventParamsRepo = SharedPrefCustomEmitEventParamsRepo(
                    context.getSharedPreferences(
                        "sdk",
                        Context.MODE_PRIVATE
                    )
                )
            ) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}