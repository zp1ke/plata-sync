package org.zp1ke.platasync.util

import java.text.NumberFormat
import java.time.OffsetDateTime
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle
import java.util.*

actual fun formatMoney(amount: Int): String = (
        NumberFormat.getCurrencyInstance().apply {
            currency = Currency.getInstance("USD")
        }
        ).format(amount.toDouble() / 100)

actual fun formatDateTime(datetime: OffsetDateTime): String =
    datetime.format(DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT))

actual fun formatDate(datetime: OffsetDateTime): String =
    datetime.format(DateTimeFormatter.ofLocalizedDate(FormatStyle.SHORT))

