package org.zp1ke.platasync.model

import kotlinx.serialization.Serializable

@Serializable
data class UserCategory(
    val id: String,
    val name: String,
)