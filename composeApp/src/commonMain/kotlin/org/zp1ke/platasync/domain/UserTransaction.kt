package org.zp1ke.platasync.domain

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.Ignore
import androidx.room.PrimaryKey
import org.zp1ke.platasync.model.TransactionType
import java.time.OffsetDateTime

@Entity(tableName = UserTransaction.TABLE_NAME)
data class UserTransaction(
    @PrimaryKey
    val id: String,
    @ColumnInfo(name = DomainModel.COLUMN_CREATED_AT, index = true)
    val createdAt: OffsetDateTime,
    @ColumnInfo(name = COLUMN_ACCOUNT_ID, index = true)
    val accountId: String,
    @ColumnInfo(name = COLUMN_TARGET_ACCOUNT_ID, index = true)
    val targetAccountId: String?,
    @ColumnInfo(name = COLUMN_CATEGORY_ID, index = true)
    val categoryId: String?,
    val description: String?,
    val amount: Int,
    @ColumnInfo(name = COLUMN_TRANSACTION_TYPE, index = true)
    val transactionType: TransactionType,
    @ColumnInfo(name = COLUMN_DATETIME, index = true)
    val datetime: OffsetDateTime,
) : DomainModel {
    companion object {
        const val TABLE_NAME = "users_transactions"

        const val COLUMN_ACCOUNT_ID = "account_id"
        const val COLUMN_TARGET_ACCOUNT_ID = "target_account_id"
        const val COLUMN_CATEGORY_ID = "category_id"
        const val COLUMN_AMOUNT = "amount"
        const val COLUMN_TRANSACTION_TYPE = "transaction_type"
        const val COLUMN_DATETIME = "datetime"
    }

    @Ignore
    override fun id(): String = id

    @Ignore
    override fun createdAt(): OffsetDateTime = createdAt
}
