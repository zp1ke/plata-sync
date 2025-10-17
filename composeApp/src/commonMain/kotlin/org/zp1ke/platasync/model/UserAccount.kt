package org.zp1ke.platasync.model

import kotlinx.serialization.Serializable
import org.zp1ke.platasync.ui.common.AppIcon

@Serializable
data class UserAccount(
    override val id: String,
    val name: String,
    val icon: AppIcon,
    val balance: Int,
) : BaseModel(id)
