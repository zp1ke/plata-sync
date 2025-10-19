package org.zp1ke.platasync.util

import kotlin.uuid.ExperimentalUuidApi
import kotlin.uuid.Uuid

@OptIn(ExperimentalUuidApi::class)
fun randomId(): String {
    val uuid = Uuid.random().toString()
    return uuid.replace("-", "").lowercase()
}
