package org.zp1ke.platasync.model

import kotlinx.serialization.Serializable

@Serializable
data class UserAccount(
    val id: String,
    val name: String,
    val icon: AppIcon,
    val balance: Int,
)