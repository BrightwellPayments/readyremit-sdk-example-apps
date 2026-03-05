package com.brightwell.composeSampleApp

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.brightwell.composeSampleApp.network.ReadyRemitService
import com.brightwell.composeSampleApp.network.model.AuthRequest
import com.brightwell.readyremit.sdk.AccessTokenDetails
import com.brightwell.readyremit.sdk.AuthenticationResult
import com.brightwell.readyremit.sdk.Localization
import com.brightwell.readyremit.sdk.ReadyRemitConfiguration
import com.brightwell.readyremit.sdk.ReadyRemitEnvironment
import com.brightwell.readyremit.sdk.ReadyRemitError
import com.brightwell.readyremit.sdk.ReadyRemitEvent
import com.brightwell.readyremit.sdk.RemittanceServiceProvider
import com.brightwell.readyremit.sdk.SDKClosed
import com.brightwell.readyremit.sdk.SDKLaunched
import com.brightwell.readyremit.sdk.SourceAccount
import com.brightwell.readyremit.sdk.SupportedAppearance
import com.brightwell.readyremit.sdk.TransferSubmissionResult
import com.brightwell.readyremit.sdk.core.domain.model.CountryIso3Code
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import java.math.BigDecimal

class MainViewModel : ViewModel() {

    private val _state = MutableStateFlow(MainState(createSdkConfig()))
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

    fun createSdkConfig(): ReadyRemitConfiguration {
        return ReadyRemitConfiguration(
            defaultCountry = null, // CountryIso3Code.USA
            environment = ReadyRemitEnvironment.SANDBOX,
            fixedRemittanceServiceProvider = null, // RemittanceServiceProvider.VISA
            fixedTransferMethod = null, // allows any transfer method
            localization = Localization.enUS,
            sourceAccounts = listOf(
                SourceAccount(
                    alias = "Account 1",
                    balance = BigDecimal("8909.99"),
                    last4 = "5590",
                    sourceProviderId = "asd12-asc123-vdsf3"
                )
            ),
            idleTimeoutInterval = 3 * 60, // measured in seconds
            appearance = "", // pass JSON value for appearance
            supportedAppearance = SupportedAppearance.Device, // adapts to light or dark mode
            authenticateIntoTheSdk = {
                withContext(Dispatchers.IO) {
                    try {
                        val senderId = "< your sender id >"
                        val clientId = "<your client id>"
                        val clientSecret = "<your client id>"
                        val request = AuthRequest(
                            clientId = clientId,
                            clientSecret = clientSecret,
                            senderId = senderId
                        )
                        val authResponse = service.auth(request)
                        withContext(Dispatchers.Main) {
                            AuthenticationResult.Success(
                                AccessTokenDetails(
                                    accessToken = authResponse.token,
                                    expiresIn = authResponse.expiresIn,
                                    scope = authResponse.scope,
                                    tokenType = authResponse.tokenType
                                )
                            )
                        }
                    } catch (e: Exception) {
                        withContext(Dispatchers.Main) {
                            AuthenticationResult.Error(
                                ReadyRemitError(
                                    code = "",
                                    message = e.message.orEmpty(),
                                    description = e.message.orEmpty()
                                )
                            )
                        }
                    }
                }
            },
            submitTransfer = { transferRequest ->
                TransferSubmissionResult.Success(
                    transferId = ""
                )
            },
            sdkEventListener = { event: ReadyRemitEvent ->
                viewModelScope.launch {
                    when (event) {
                        SDKLaunched -> {
                            // do something
                        }

                        SDKClosed -> {
                            // do something
                        }
                    }
                }
            }
        )
    }

}