package org.zp1ke.platasync.domain

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.AppIcon
import java.time.OffsetDateTime

@Entity(tableName = UserCategory.TABLE_NAME)
data class UserCategory(
    @PrimaryKey
    override val id: String,
    @ColumnInfo(name = COLUMN_CREATED_AT, index = true)
    override val createdAt: OffsetDateTime,
    @ColumnInfo(index = true)
    val name: String,
    val icon: AppIcon,
    @ColumnInfo(name = COLUMN_TRANSACTION_TYPES, index = true)
    val transactionTypes: List<TransactionType>
) : BaseModel(id, createdAt) {
    companion object {
        const val TABLE_NAME = "users_categories"

        const val COLUMN_NAME = "name"
        const val COLUMN_TRANSACTION_TYPES = "transaction_types"
    }
}
