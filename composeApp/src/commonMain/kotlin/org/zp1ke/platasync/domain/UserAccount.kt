package org.zp1ke.platasync.domain

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import org.zp1ke.platasync.ui.common.AppIcon
import java.time.OffsetDateTime

@Entity(tableName = UserAccount.TABLE_NAME)
data class UserAccount(
    @PrimaryKey
    override val id: String,
    @ColumnInfo(name = COLUMN_CREATED_AT, index = true)
    override val createdAt: OffsetDateTime,
    @ColumnInfo(index = true)
    val name: String,
    val icon: AppIcon,
    val initialBalance: Int,
    @ColumnInfo(name = COLUMN_BALANCE)
    val balance: Int = initialBalance,
) : BaseModel(id, createdAt) {
    companion object {
        const val TABLE_NAME = "users_accounts"

        const val COLUMN_NAME = "name"
        const val COLUMN_BALANCE = "balance"
    }
}
