package org.zp1ke.platasync.data.model

import androidx.room.Embedded
import androidx.room.Relation
import org.zp1ke.platasync.domain.UserAccount
import org.zp1ke.platasync.domain.UserCategory
import org.zp1ke.platasync.domain.UserTransaction

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
)
