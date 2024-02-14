package com.solitics.integration.app.domain.utils

import android.util.Log

val Any.TAG: String
        get() {
        val tag = javaClass.simpleName
        return if (tag.length <= 23) tag else tag.substring(0, 23)
        }

fun Any.log(tag: String = TAG, message: String) = Log.d(tag, message)