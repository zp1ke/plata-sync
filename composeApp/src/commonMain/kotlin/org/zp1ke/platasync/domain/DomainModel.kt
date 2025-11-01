package org.zp1ke.platasync.domain

import java.time.OffsetDateTime

interface DomainModel {
    fun id(): String

    fun createdAt(): OffsetDateTime

    companion object {
        const val COLUMN_CREATED_AT = "created_at"
    }
}
