package com.solitics.integration.app.repo

import android.content.SharedPreferences
import com.google.gson.Gson

import com.solitics.integration.app.data.CustomEmitEventParams
import com.solitics.integration.app.data.ICustomEmitEventParams
import com.solitics.sdk.domain.EventType

class SharedPrefCustomEmitEventParamsRepo(
    private val sharePref: SharedPreferences
) : ICustomEmitEventParamsRepo {

    private val KEY = "custom_params"

    override fun load(): ICustomEmitEventParams {
        val dataString = sharePref.getString(KEY, "")
        if (dataString!!.isEmpty()) {
            return CustomEmitEventParams(EventType.EMIT_EVENT.type, null, null)
        }

        return Gson().fromJson(dataString, CustomEmitEventParams::class.java)
    }

    override fun save(params: ICustomEmitEventParams) {
        sharePref
            .edit()
            .putString(
                KEY,
                Gson().toJson(params)
            )
            .apply()
    }

    override fun clean() {
        sharePref
            .edit()
            .putString(
                KEY,
                ""
            )
            .apply()
    }
}
