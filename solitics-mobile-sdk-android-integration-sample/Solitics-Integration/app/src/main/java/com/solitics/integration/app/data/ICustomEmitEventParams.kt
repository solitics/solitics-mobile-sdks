package com.solitics.integration.app.data

import java.io.Serializable

interface ICustomEmitEventParams : Serializable {
    var txType: String?
    var customFields: String?
    var txAmount: Double?
}