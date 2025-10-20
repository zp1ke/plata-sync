package org.zp1ke.platasync.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import org.zp1ke.platasync.ui.common.AppIcon
import java.time.OffsetDateTime

@Entity(tableName = "users_accounts")
data class UserAccount(
    @PrimaryKey
    override val id: String,
    @ColumnInfo(name = COLUMN_CREATED_AT)
    override val createdAt: OffsetDateTime,
    val name: String,
    val icon: AppIcon,
    @ColumnInfo(name = COLUMN_INITIAL_BALANCE)
    val initialBalance: Int,
) : BaseModel(id, createdAt) {
    companion object {
        const val TABLE_NAME = "users_accounts"

        const val COLUMN_NAME = "name"
        const val COLUMN_INITIAL_BALANCE = "initial_balance"
    }
}
