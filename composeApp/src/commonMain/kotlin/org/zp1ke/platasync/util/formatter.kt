package org.zp1ke.platasync.util

expect fun formatMoney(amount: Int): String

fun Int.formatAsMoney() = formatMoney(this)
