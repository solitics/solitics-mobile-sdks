package com.solitics.integration.app.presentation.home

import android.os.Bundle
import android.text.Editable
import android.util.Log
import android.view.View
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.solitics.integration.app.R
import com.solitics.integration.app.domain.utils.TAG
import com.solitics.integration.app.presentation.common.DelayedAfterTextChangedWatcher
import com.solitics.integration.app.presentation.common.EmptyTextWatcher
import com.solitics.sdk.SoliticsLogListener
import com.solitics.sdk.SoliticsSDK
import com.solitics.sdk.SoliticsPopupDelegate
import com.solitics.sdk.domain.PopupContent

class HomeActivity : AppCompatActivity(), SoliticsLogListener, SoliticsPopupDelegate {
    private lateinit var viewModel: HomeViewModel
    private lateinit var tvLog: TextView
    private lateinit var tvDelegateLog: TextView
    private lateinit var cbShouldShowPopup: CheckBox
    private lateinit var cbIsDelegateActive: CheckBox
    private lateinit var svLogDelegate: ScrollView

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
        "Host app : subscribe on socket event..\n".also { tvLog.text = it }

        tvDelegateLog = findViewById(R.id.tvLogDelagate)
        cbShouldShowPopup = findViewById(R.id.cbShouldShowPopup)
        cbIsDelegateActive = findViewById(R.id.cbActivateDelagate)
        svLogDelegate = findViewById(R.id.svLogDelagate)

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

        cbIsDelegateActive.setOnCheckedChangeListener { checkButton, isChecked ->
            if(checkButton.isPressed) { // check state has changed by the user
                setDelegateActivate(isChecked)
            }
        }

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
        setDelegateActivate(cbIsDelegateActive.isChecked)

    }

    override fun onDestroy() {
        super.onDestroy()
        SoliticsSDK.removeSoliticsLogListener(this)
    }

    override fun onMessage(message: String) {
        runOnUiThread {
            val oldLog = tvLog.text.toString()
            (oldLog + message).also { tvLog.text = it }
        }
    }

    override fun popupShouldOpen(message: PopupContent): Boolean {
        Log.d(TAG, "popupShouldOpen: ")
        return cbShouldShowPopup.isChecked
    }

    override fun onPopupOpened() {
        Log.d(TAG, "onPopupOpened: ")
        onDelegateMessage("onPopupOpened" )
    }
    override fun onPopupClicked() {
        Log.d(TAG, "onPopupClicked: ")
        onDelegateMessage("onPopupClicked" )
    }
    override fun onPopupClosed() {
        Log.d(TAG, "onPopupClosed: ")
        onDelegateMessage("onPopupClosed" )
    }

    private fun onDelegateMessage(message: String) {
        runOnUiThread {
            val oldLog = tvDelegateLog.text.toString()
            (oldLog + "\n" + message).also { tvDelegateLog.text = it }
            svLogDelegate.post {
                svLogDelegate.fullScroll(View.FOCUS_DOWN)
            }
        }
    }

    private fun setDelegateActivate(isActive: Boolean) {
        if (isActive) {
            cbIsDelegateActive.isChecked = true
            cbShouldShowPopup.isEnabled = true
            SoliticsSDK.setSoliticsPopupDelegate(this)
        } else {
            cbIsDelegateActive.isChecked = false
            cbShouldShowPopup.isEnabled = false
            SoliticsSDK.setSoliticsPopupDelegate(null)
        }
    }
}