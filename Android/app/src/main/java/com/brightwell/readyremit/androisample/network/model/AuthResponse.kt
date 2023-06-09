package com.brightwell.readyremit.androisample.network.model

import com.squareup.moshi.Json

data class AuthResponse(
    @Json(name = "access_token") val token: String
)
