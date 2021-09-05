package com.solitics.integration.app.data

class CustomEmitEventParams(
    override var txType: String?,
    override var customFields: String?,
    override var txAmount: Double?
) : ICustomEmitEventParams