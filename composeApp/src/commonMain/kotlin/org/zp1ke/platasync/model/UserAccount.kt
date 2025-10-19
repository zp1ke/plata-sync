package org.zp1ke.platasync.model

import androidx.room.Entity
import androidx.room.PrimaryKey
import org.zp1ke.platasync.ui.common.AppIcon

@Entity
data class UserAccount(
    @PrimaryKey
    override val id: String,
    val name: String,
    val icon: AppIcon,
    val balance: Int,
) : BaseModel(id)
