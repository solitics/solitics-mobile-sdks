package com.solitics.integration.app.presentation.home

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.Editable
import android.util.Log
import android.view.View
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.solitics.integration.app.R
import com.solitics.integration.app.domain.utils.TAG
import com.solitics.integration.app.domain.utils.log
import com.solitics.integration.app.presentation.common.DelayedAfterTextChangedWatcher
import com.solitics.integration.app.presentation.common.EmptyTextWatcher
import com.solitics.sdk.SoliticsSDK
import com.solitics.sdk.SoliticsLogListener
import com.solitics.sdk.SoliticsPopupDelegate
import com.solitics.sdk.domain.PopupContent

class HomeActivity : AppCompatActivity(), SoliticsLogListener, SoliticsPopupDelegate {
    private lateinit var viewModel: HomeViewModel
    private lateinit var tvLog: TextView
    private lateinit var tvDelegateLog: TextView
    private lateinit var cbShouldShowPopup: CheckBox
    private lateinit var cbShouldDismissForNavigationClick: CheckBox
    private lateinit var cbIsDelegateActive: CheckBox
    private lateinit var svLogDelegate: ScrollView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)

        ViewModelProvider(this, HomeViewModelFactory(this))[HomeViewModel::class.java].also { viewModel = it }

        findViewById<Button>(R.id.btnSendEvent).setOnClickListener {
            viewModel.sendEvent()
        }
        findViewById<Button>(R.id.btnLogOut).setOnClickListener {
            viewModel.logOut()
        }
        tvLog = findViewById(R.id.tvLog)
        "Host app : subscribe on socket event..\n".also { tvLog.text = it }

        tvDelegateLog = findViewById(R.id.tvLogDelegate)
        cbShouldShowPopup = findViewById(R.id.cbShouldShowPopup)
        cbShouldDismissForNavigationClick = findViewById(R.id.cbShouldDismissForNavigationClick)
        cbIsDelegateActive = findViewById(R.id.cbActivateDelegate)
        svLogDelegate = findViewById(R.id.svLogDelegate)

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
        handleIntent(intent)
    }

    override fun onDestroy() {
        super.onDestroy()
        SoliticsSDK.removeSoliticsLogListener(this)
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        Log.d(TAG, "onNewIntent: $intent")

        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {

        if (intent != null && intent.extras != null) {
            for (key in intent.extras!!.keySet()) {
                log("LoginActivity", "key: $key")
                log("LoginActivity", "value: ${intent.extras!!.get(key)}")
            }
        }
        SoliticsSDK.onNewIntent(intent)
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

        dismissPopup()
    }
    override fun onPopupClicked() {
        Log.d(TAG, "onPopupClicked: ")
        onDelegateMessage("onPopupClicked" )
    }
    override fun onPopupClosed() {
        Log.d(TAG, "onPopupClosed: ")
        onDelegateMessage("onPopupClosed" )
    }

    override fun popupShouldDismissForNavigationOnClickTrigger(urlString: String): Boolean {
        Log.d(TAG, "popupShouldDismissForNavigationOnClickTrigger: $urlString")
        return cbShouldDismissForNavigationClick.isChecked
    }

    override fun onPopupClosedForNavigationOnClickTrigger(urlString: String) {
        Log.d(TAG, "onPopupClosedForNavigationOnClickTrigger: $urlString")
        onDelegateMessage("onPopupClosedForNavigationOnClickTrigger $urlString")

        // add your navigation logic here
        startFirstActivity()
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
            cbShouldDismissForNavigationClick.isEnabled = true
            SoliticsSDK.setSoliticsPopupDelegate(this)
        } else {
            cbIsDelegateActive.isChecked = false
            cbShouldShowPopup.isEnabled = false
            cbShouldDismissForNavigationClick.isEnabled = false
            SoliticsSDK.setSoliticsPopupDelegate(null)
        }
    }

    private fun startFirstActivity(){
        startActivity(Intent(this, FirstActivity::class.java))
    }

    private fun dismissPopup() {
        Handler(Looper.getMainLooper()).postDelayed({
            SoliticsSDK.dismissSoliticsPopup()
        }, 5000L)
    }
}