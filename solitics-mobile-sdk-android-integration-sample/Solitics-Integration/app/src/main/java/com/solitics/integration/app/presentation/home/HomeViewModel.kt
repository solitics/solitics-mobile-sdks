package com.solitics.integration.app.presentation.home

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.solitics.integration.app.data.ICustomEmitEventParams
import com.solitics.integration.app.domain.utils.isJson
import com.solitics.integration.app.repo.ICustomEmitEventParamsRepo
import com.solitics.sdk.SoliticsSDK
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class HomeViewModel(
        private val resetToLoginScreen: () -> Unit,
        private val customEmitEventParamsRepo: ICustomEmitEventParamsRepo
) : ViewModel() {

    private val customParamsData: MutableLiveData<ICustomEmitEventParams> = MutableLiveData()

    fun onStart() {
        customParamsData.value = customEmitEventParamsRepo.load()
    }

    fun onTxTypeEntered(text: String) {
        val params = customEmitEventParamsRepo.load()
        params.txType = text
        customEmitEventParamsRepo.save(params)
    }

    fun onTxAmountEntered(amount: Double) {
        val params = customEmitEventParamsRepo.load()
        params.txAmount = amount
        customEmitEventParamsRepo.save(params)
    }

    fun onCustomFieldsEntered(text: String) {
        if (!text.isJson()) {
            throw IllegalArgumentException("It's not a json format")
        }
        val params = customEmitEventParamsRepo.load()
        params.customFields = text
        customEmitEventParamsRepo.save(params)
    }

    fun sendEvent() {

        viewModelScope.launch {

            withContext(Dispatchers.IO) {

                customEmitEventParamsRepo.load().let {

                    SoliticsSDK.onEmitEvent(
                            it.txType.toString(),
                            it.txAmount,
                            it.customFields.toString()
                    )
                }
            }

        }
    }

    fun logOut() {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                SoliticsSDK.onLogout()
                customEmitEventParamsRepo.clean()
            }
            withContext(Dispatchers.Main) {
                resetToLoginScreen.invoke()
            }
        }
    }

    fun getCustomParams() = customParamsData
}