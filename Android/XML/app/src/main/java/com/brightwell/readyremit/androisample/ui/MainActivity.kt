package com.brightwell.readyremit.androisample.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.brightwell.readyremit.androisample.databinding.ActivityMainBinding
import com.brightwell.readyremit.sdk.environment.Environment
import com.brightwell.readyremit.sdk.ReadyRemit
import com.brightwell.readyremit.sdk.ReadyRemitAuthCallback
import com.brightwell.readyremit.sdk.ReadyRemitTransferCallback
import com.brightwell.readyremit.sdk.ReadyRemitTransferRequest

class MainActivity : AppCompatActivity() {

    private var _binding: ActivityMainBinding? = null
    private val binding get() = _binding!!

    private val viewModel: MainViewModel = MainViewModel()

    private val clientID = "ymZyGsLmCmhz7GMSQQ5OKUVxYrtuHfot"
    private val clientSecret = "PoPLoW8Y0EqayFhvfLEVcUb-qGTenDETN-cYww_9R5_Z99IVc4bfo6qP4dUjjikT"
    private val senderID = "3d3b2929-aaae-4eb3-b26f-4b6bc83cde26"

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
            .useEnvironment(Environment.SANDBOX)
            .useAuthProvider { callback -> requestReadyRemitAccessToken(callback) }
            .useTransferSubmitProvider { request, callback ->
                submitReadyRemitTransfer(
                    request, callback
                )
            }
            .useLanguage("en-US")
            .build())
    }

    private fun requestReadyRemitAccessToken(callback: ReadyRemitAuthCallback) {
        viewModel.doAuth(clientID, clientSecret, senderID, callback)
    }

    private fun submitReadyRemitTransfer(
        request: ReadyRemitTransferRequest,
        callback: ReadyRemitTransferCallback
    ) {
        //Request transfer from your API
    }
}