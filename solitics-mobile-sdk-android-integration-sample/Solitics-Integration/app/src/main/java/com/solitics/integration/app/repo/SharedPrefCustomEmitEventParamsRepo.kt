package com.solitics.integration.app.repo

import android.content.SharedPreferences
import com.google.gson.Gson

import com.solitics.integration.app.data.CustomEmitEventParams
import com.solitics.integration.app.data.ICustomEmitEventParams

class SharedPrefCustomEmitEventParamsRepo(
    private val sharePref: SharedPreferences
) : ICustomEmitEventParamsRepo {

    private val storageKey = "custom_params"

    override fun load(): ICustomEmitEventParams {
        val dataString = sharePref.getString(storageKey, "")
        if (dataString!!.isEmpty()) {
            return CustomEmitEventParams("Gini", "{}", 10.0)
        }

        return Gson().fromJson(dataString, CustomEmitEventParams::class.java)
    }

    override fun save(params: ICustomEmitEventParams) {
        sharePref
            .edit()
            .putString(
                storageKey,
                Gson().toJson(params)
            )
            .apply()
    }

    override fun clean() {
        sharePref
            .edit()
            .putString(
                storageKey,
                ""
            )
            .apply()
    }
}
