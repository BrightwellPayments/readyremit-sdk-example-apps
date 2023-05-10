package com.readyremit_demo // Put your package name here

import android.util.Log
import com.brightwell.readyremit.sdk.*
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import kotlinx.coroutines.runBlocking
import com.google.gson.Gson
import com.readyremitreactnativesample.R
import kotlinx.coroutines.*

class ReadyRemitModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    private val REQUEST_CODE = 10
    private val READYREMIT_AUTH_TOKEN_REQUESTED = "READYREMIT_AUTH_TOKEN_REQUESTED"
    private val READYREMIT_TRANSFER_SUBMITTED = "READYREMIT_TRANSFER_SUBMITTED"
    private val READYREMIT_SDK_CLOSE = "SDK_CLOSED"
    private lateinit var _onAuthCallback: ReadyRemitAuthCallback
    private lateinit var _onTransferCallback: ReadyRemitTransferCallback

    override fun getName(): String {
        return "ReadyRemitModule"
    }

    @ReactMethod
    fun launch(environment: String, language: String = "en", style: ReadableMap? = null) {

        ReadyRemit.initialize(
            ReadyRemit.Config.Builder(currentActivity!!.application)
                .useEnvironment(if(environment == "PRODUCTION") Environment.PRODUCTION else Environment.SANDBOX)
                .useAuthProvider { callback -> requestReadyRemitAccessToken(callback) }
                .useTransferSubmitProvider  { request, callback -> submitReadyRemitTransfer(request, callback) }
                .useDefaultTheme(R.style.Theme_Custom)
                .useLanguage(language)
                .build()
        )

        ReadyRemit.remitFrom(currentActivity!!, REQUEST_CODE, R.style.Theme_Custom, language)

        ReadyRemit.setEventListener { event ->
            when (event) {
                SDKClosed -> {
                    reactApplicationContext
                        .getJSModule(RCTDeviceEventEmitter::class.java)
                        .emit(READYREMIT_SDK_CLOSE, null)
                }

                else -> Log.d("NOT IMPLEMENTED", "NOT IMPLEMENTED")
            }
        }
    }

    @ReactMethod
    fun setAuthToken(token: String, errorAuthCode: String?) {
        if (token != "") {
            _onAuthCallback.onAuthSucceeded(ReadyRemitAuth(token, ""))
        } else {
            _onAuthCallback.onAuthFailed()
        }
    }

    private fun requestReadyRemitAccessToken(callback: ReadyRemitAuthCallback) {
        runBlocking {
            _onAuthCallback = callback

            reactApplicationContext
                .getJSModule(RCTDeviceEventEmitter::class.java)
                .emit(READYREMIT_AUTH_TOKEN_REQUESTED, null)
        }
    }

    @ReactMethod
    fun setTransferId(transferId: String? = "", errorCode: String? = "", errorMessage: String? = "") {
        if (transferId != "" && transferId != null) {
            _onTransferCallback.onTransferSucceeded(transferId)
        } else if (errorCode != null) {
            val error = ReadyRemitError(errorCode, errorMessage ?: "", errorMessage ?: "")
            _onTransferCallback.onTransferFailed(error)
        }
    }

    private suspend fun submitReadyRemitTransfer(
        request: ReadyRemitTransferRequest,
        callback: ReadyRemitTransferCallback
    ) {
        _onTransferCallback = callback

        var jsonRequest = Gson().toJson(request)

        reactApplicationContext
            .getJSModule(RCTDeviceEventEmitter::class.java)
            .emit(READYREMIT_TRANSFER_SUBMITTED, jsonRequest)
    }
}