package com.solitics.integration.app.domain.utils


fun String.isJson(): Boolean {

    return if (this.length < 2) {
        false
    } else this.contains("{") && this.contains("}")
}