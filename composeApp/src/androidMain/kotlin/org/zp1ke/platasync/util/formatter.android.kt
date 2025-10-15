package org.zp1ke.platasync.util

import java.text.NumberFormat
import java.util.*

actual fun formatMoney(amount: Int): String = (
        NumberFormat.getCurrencyInstance().apply {
            currency = Currency.getInstance("USD")
        }
        ).format(amount.toFloat() / 100)
