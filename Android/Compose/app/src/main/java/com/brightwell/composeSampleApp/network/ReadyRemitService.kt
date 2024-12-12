package com.brightwell.composeSampleApp.network

import com.brightwell.readyremit.androisample.network.model.AuthRequest
import com.brightwell.readyremit.androisample.network.model.AuthResponse
import com.brightwell.readyremit.androisample.network.model.TransferResponse
import com.brightwell.readyremit.sdk.ReadyRemitTransferRequest
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.POST

interface ReadyRemitService {

    @POST("/v1/oauth/token")
    @Headers("Content-Type: application/json")
    suspend fun auth(@Body authRequest: AuthRequest): AuthResponse

    @POST("v1/transfers")
    @Headers(
        "Content-Type: application/json",
        "ACCEPT-LANGUAGE: en_US"
    )
    suspend fun transfer(@Header("Authorization") token: String,
                         @Body transferRequest: ReadyRemitTransferRequest): Response<TransferResponse>

}