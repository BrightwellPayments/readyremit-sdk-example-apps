package com.brightwell.readyremit.androisample.ui

import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import com.brightwell.readyremit.androisample.databinding.ActivityMainBinding
import com.brightwell.readyremit.sdk.ReadyRemit
import com.brightwell.readyremit.sdk.ReadyRemitAuthCallback
import com.brightwell.readyremit.sdk.ReadyRemitTransferCallback
import com.brightwell.readyremit.sdk.ReadyRemitTransferRequest
import com.brightwell.readyremit.sdk.environment.Environment

class MainActivity : AppCompatActivity() {

    private var _binding: ActivityMainBinding? = null
    private val binding get() = _binding!!

    private val viewModel: MainViewModel by viewModels()

    private val clientID = "rrBlzRSPg5U7xjvFfZx19iifiuB6Pkuc"
    private val clientSecret = "vvSts6__lEUd_OkppaVnKqY4VVr05hsdTr5ny7nsz_6t471UrK-24t7St9h2Aht_"
    private val senderID = "c2763cb6-8ce1-4c7c-8758-4dbcba3efc7a"

    companion object {
        private const val REQUEST_CODE = 1
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        _binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        initializeSDK()
        setupListeners()
    }

    private fun setupListeners() {
        binding.btStartSdk.setOnClickListener {
            ReadyRemit.remitFrom(this, REQUEST_CODE)
        }
    }

    private fun initializeSDK() {
        ReadyRemit.initialize(ReadyRemit.Config.Builder(application)
            .useEnvironment(Environment.UAT)
            .useAuthProvider { callback -> requestReadyRemitAccessToken(callback) }
            .useTransferSubmitProvider { request, callback ->
                submitReadyRemitTransfer(
                    request, callback
                )
            }
            .useLanguage("en")
            .build())
    }

    private fun requestReadyRemitAccessToken(callback: ReadyRemitAuthCallback) {
        viewModel.doAuth(clientID, clientSecret, senderID, callback)
    }

    private fun submitReadyRemitTransfer(
        request: ReadyRemitTransferRequest, callback: ReadyRemitTransferCallback
    ) {
        //Request transfer from your API
    }
}