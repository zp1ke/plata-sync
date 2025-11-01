package org.zp1ke.platasync.data.model

import androidx.room.Embedded
import androidx.room.Relation
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.domain.UserAccount
import org.zp1ke.platasync.domain.UserCategory
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.TransactionType
import java.time.OffsetDateTime

data class UserFullTransaction(
    @Embedded val transaction: UserTransaction,
    @Relation(
        parentColumn = UserTransaction.COLUMN_ACCOUNT_ID,
        entityColumn = "id",
        entity = UserAccount::class,
    )
    val account: UserAccount,
    @Relation(
        parentColumn = UserTransaction.COLUMN_TARGET_ACCOUNT_ID,
        entityColumn = "id",
        entity = UserAccount::class,
    )
    val targetAccount: UserAccount?,
    @Relation(
        parentColumn = UserTransaction.COLUMN_CATEGORY_ID,
        entityColumn = "id",
        entity = UserCategory::class,
    )
    val category: UserCategory?,
) : DomainModel {

    /**
     * Returns the signed amount based on transaction type:
     * - INCOME: positive amount (money coming in)
     * - EXPENSE: negative amount (money going out)
     * - TRANSFER: negative amount (money leaving this account)
     */
    val signedAmount: Int
        get() = when (transaction.transactionType) {
            TransactionType.INCOME -> transaction.amount
            TransactionType.EXPENSE -> -transaction.amount
            TransactionType.TRANSFER -> -transaction.amount
        }

    val transactionType: TransactionType
        get() = transaction.transactionType

    override fun id(): String = transaction.id

    override fun createdAt(): OffsetDateTime = transaction.createdAt
}
