package org.zp1ke.platasync.util

import kotlin.uuid.ExperimentalUuidApi
import kotlin.uuid.Uuid

@OptIn(ExperimentalUuidApi::class)
fun randomId(len: Int = 6): String {
    var uuid = Uuid.random().toString()
    uuid = uuid.replace("-", "").lowercase()
    return uuid.take(len)
}
