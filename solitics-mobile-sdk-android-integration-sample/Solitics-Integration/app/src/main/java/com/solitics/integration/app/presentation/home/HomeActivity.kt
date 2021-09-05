package com.solitics.integration.app.presentation.home

import android.os.Bundle
import android.text.Editable
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.solitics.integration.app.R
import com.solitics.integration.app.presentation.common.DelayedAfterTextChangedWatcher
import com.solitics.integration.app.presentation.common.EmptyTextWatcher
import com.solitics.sdk.SoliticsSDK
import com.solitics.sdk.domain.SoliticsLogListener

class HomeActivity : AppCompatActivity(), SoliticsLogListener {
    private lateinit var viewModel: HomeViewModel
    private lateinit var tvLog: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)

        viewModel = ViewModelProvider(this, HomeViewModelFactory(this))
            .get(HomeViewModel::class.java)

        findViewById<Button>(R.id.btnSendEvent).setOnClickListener {
            viewModel.sendEvent()
        }
        findViewById<Button>(R.id.btnLogOut).setOnClickListener {
            viewModel.logOut()
        }
        tvLog = findViewById(R.id.tvLog)
        tvLog.text = "Host app : subscribe on socket event..\n"

        setupCustomFields()
    }

    private fun setupCustomFields() {
        findViewById<EditText>(R.id.etTxAmount).addTextChangedListener(
            DelayedAfterTextChangedWatcher(
                object : EmptyTextWatcher() {
                    override fun afterTextChanged(s: Editable?) {
                        findViewById<EditText>(R.id.etTxAmount).error = null
                        try {
                            viewModel.onTxAmountEntered(s.toString().toDouble())
                        } catch (e: Exception) {
                            findViewById<EditText>(R.id.etTxAmount).error = "Check entered data"
                        }
                    }
                }
            )
        )

        findViewById<EditText>(R.id.etCustomFields).addTextChangedListener(
            DelayedAfterTextChangedWatcher(
                object : EmptyTextWatcher() {
                    override fun afterTextChanged(s: Editable?) {
                        findViewById<EditText>(R.id.etCustomFields).error = null
                        try {
                            viewModel.onCustomFieldsEntered(s.toString())
                        } catch (e: Exception) {
                            findViewById<EditText>(R.id.etCustomFields).error = "Check entered data"
                        }
                    }
                }
            )
        )

        findViewById<EditText>(R.id.etTxType).addTextChangedListener(
            DelayedAfterTextChangedWatcher(
                object : EmptyTextWatcher() {
                    override fun afterTextChanged(s: Editable?) {
                        findViewById<EditText>(R.id.etTxType).error = null
                        try {
                            viewModel.onTxTypeEntered(s.toString())
                        } catch (e: Exception) {
                            findViewById<EditText>(R.id.etTxType).error = "Check entered data"
                        }
                    }
                }
            )
        )

        viewModel.getCustomParams().observe(this, Observer {
            if (it === null) {
                return@Observer
            }

            findViewById<EditText>(R.id.etTxAmount).setText(it.txAmount?.toString())
            findViewById<EditText>(R.id.etCustomFields).setText(it.customFields)
            findViewById<EditText>(R.id.etTxType).setText(it.txType)
        })
    }

    override fun onStart() {
        super.onStart()
        viewModel.onStart()
    }

    override fun onResume() {
        super.onResume()
        SoliticsSDK.registerSoliticsLogListener(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        SoliticsSDK.removeSoliticsLogListener(this)
    }

    override fun onMessage(message: String) {
        runOnUiThread {
            val oldLog = tvLog.text.toString()
            tvLog.text = oldLog + message
        }
    }
}