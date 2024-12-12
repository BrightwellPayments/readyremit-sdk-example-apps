package com.brightwell.composeSampleApp

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.brightwell.composeSampleApp.network.ReadyRemitService
import com.brightwell.readyremit.androisample.network.model.AuthRequest
import com.brightwell.readyremit.sdk.ReadyRemit
import com.brightwell.readyremit.sdk.ReadyRemitAuth
import com.brightwell.readyremit.sdk.ReadyRemitAuthCallback
import com.brightwell.readyremit.sdk.ReadyRemitTransferCallback
import com.brightwell.readyremit.sdk.ReadyRemitTransferRequest
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

class MainViewModel: ViewModel() {

    private val _state = MutableStateFlow(MainState())
    val state: StateFlow<MainState> = _state

    private val service: ReadyRemitService by lazy {
        Retrofit.Builder().baseUrl("https://sandbox-api.readyremit.com")
            .client(
                OkHttpClient.Builder()
                    .addInterceptor(HttpLoggingInterceptor().apply {
                        level = HttpLoggingInterceptor.Level.BODY
                    })
                    .build()
            )
            .addConverterFactory(MoshiConverterFactory.create())
            .build().create(ReadyRemitService::class.java)
    }

    fun onAuth(
        callback: ReadyRemitAuthCallback
    ) {
        val senderId = "<Your Sender ID here>"
        val clientId = "<Your Client ID here>"
        val clientSecret = "<Your Client Secret here>"
        val request = AuthRequest(
            clientId = clientId,
            clientSecret = clientSecret,
            senderId = senderId
        )

        viewModelScope.launch {
            try {
                val token = service.auth(request).token
                _state.update { it.copy(auth = token) }
                withContext(Dispatchers.Main) {
                    callback.onAuthSucceeded(ReadyRemitAuth(token, token))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback.onAuthFailed()
                }
            }
        }
    }

    fun onTransfer(
        request: ReadyRemitTransferRequest,
        callback: ReadyRemitTransferCallback
    ) {
        // Send transfer to your backend
    }
}