package org.zp1ke.platasync.util

import java.time.OffsetDateTime

expect fun formatMoney(amount: Int): String

fun Int.formatAsMoney() = formatMoney(this)

expect fun formatDateTime(datetime: OffsetDateTime): String

fun OffsetDateTime.formatAsString() = formatDateTime(this)


