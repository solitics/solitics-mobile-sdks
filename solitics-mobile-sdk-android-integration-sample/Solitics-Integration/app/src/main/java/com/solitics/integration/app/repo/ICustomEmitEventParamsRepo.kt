package com.solitics.integration.app.repo

import com.solitics.integration.app.data.ICustomEmitEventParams

interface ICustomEmitEventParamsRepo {
    fun load(): ICustomEmitEventParams
    fun save(params: ICustomEmitEventParams)
    fun clean()
}