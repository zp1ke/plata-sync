package org.zp1ke.platasync.model

import java.time.OffsetDateTime

abstract class BaseModel(
    open val id: String,
    val createdAt: OffsetDateTime = OffsetDateTime.now(),
)
