package org.zp1ke.platasync.model

import kotlinx.serialization.Serializable
import org.zp1ke.platasync.ui.common.AppIcon

@Serializable
data class UserCategory(
    override val id: String,
    val name: String,
    val icon: AppIcon,
) : BaseModel(id)
