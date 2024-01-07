package com.solitics.integration.app.presentation.common

import android.os.Handler
import android.os.Looper
import android.text.Editable
import android.text.TextWatcher

class DelayedAfterTextChangedWatcher(
    private val origin: TextWatcher,
    private val delayInMills: Long = 500
) : TextWatcher {

    private val handler: Handler = Handler(Looper.getMainLooper())
    private var runnable: Runnable = Runnable { }

    override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {
        origin.beforeTextChanged(s, start, count, after)
    }

    override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
        origin.onTextChanged(s, start, before, count)
    }

    override fun afterTextChanged(s: Editable?) {
        handler.removeCallbacks(runnable)
        runnable = Runnable { origin.afterTextChanged(s) }
        handler.postDelayed(runnable, delayInMills)
    }
}
