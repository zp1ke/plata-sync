package org.zp1ke.platasync.domain

import java.time.OffsetDateTime

abstract class BaseModel(
    open val id: String,
    open val createdAt: OffsetDateTime = OffsetDateTime.now(),
) {
    companion object {
        const val COLUMN_CREATED_AT = "created_at"
    }
}
