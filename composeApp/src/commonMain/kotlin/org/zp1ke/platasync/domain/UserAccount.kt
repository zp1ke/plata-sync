package org.zp1ke.platasync.domain

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.Ignore
import androidx.room.PrimaryKey
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.AppIcon
import java.time.OffsetDateTime

@Entity(tableName = UserAccount.TABLE_NAME)
data class UserAccount(
    @PrimaryKey
    val id: String,
    @ColumnInfo(name = DomainModel.COLUMN_CREATED_AT, index = true)
    val createdAt: OffsetDateTime,
    @ColumnInfo(index = true)
    val name: String,
    val icon: AppIcon,
    val initialBalance: Int,
    @ColumnInfo(name = COLUMN_BALANCE)
    val balance: Int = initialBalance,
) : DomainModel {
    companion object {
        const val TABLE_NAME = "users_accounts"

        const val COLUMN_NAME = "name"
        const val COLUMN_BALANCE = "balance"
    }

    @Ignore
    override fun id(): String = id

    @Ignore
    override fun createdAt(): OffsetDateTime = createdAt

    fun balanceAfter(amount: Int, transactionType: TransactionType): Int {
        return when (transactionType) {
            TransactionType.INCOME -> balance + amount
            TransactionType.EXPENSE, TransactionType.TRANSFER -> balance - amount
        }
    }
}
