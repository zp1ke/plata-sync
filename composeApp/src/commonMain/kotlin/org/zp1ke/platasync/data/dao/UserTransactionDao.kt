package org.zp1ke.platasync.data.dao

import androidx.room.Dao
import androidx.room.Query
import androidx.room.Transaction
import androidx.room.Upsert
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.model.UserFullTransaction
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.TransactionType
import java.time.OffsetDateTime

@Dao
interface UserTransactionDao {
    @Upsert
    suspend fun save(item: UserTransaction)

    @Query(
        """
        SELECT * FROM ${UserTransaction.TABLE_NAME}
        ORDER BY 
            CASE WHEN :sortOrder = '${SortOrder.ASC_VALUE}' THEN
                CASE :sortKey
                    WHEN '${DomainModel.COLUMN_CREATED_AT}' THEN ${DomainModel.COLUMN_CREATED_AT}
                END
            END ASC,
            CASE WHEN :sortOrder = '${SortOrder.DESC_VALUE}' THEN
                CASE :sortKey
                    WHEN '${DomainModel.COLUMN_CREATED_AT}' THEN ${DomainModel.COLUMN_CREATED_AT}
                END
            END DESC
    """
    )
    suspend fun getAll(
        sortKey: String = DomainModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
    ): List<UserTransaction>

    @Transaction
    @Query(
        """
        SELECT * FROM ${UserTransaction.TABLE_NAME}
        WHERE (
            ${UserTransaction.COLUMN_DATETIME} >= :from AND
            ${UserTransaction.COLUMN_DATETIME} <= :to
        )
        ORDER BY 
            CASE WHEN :sortOrder = '${SortOrder.ASC_VALUE}' THEN
                CASE :sortKey
                    WHEN '${DomainModel.COLUMN_CREATED_AT}' THEN ${DomainModel.COLUMN_CREATED_AT}
                END
            END ASC,
            CASE WHEN :sortOrder = '${SortOrder.DESC_VALUE}' THEN
                CASE :sortKey
                    WHEN '${DomainModel.COLUMN_CREATED_AT}' THEN ${DomainModel.COLUMN_CREATED_AT}
                END
            END DESC
        LIMIT :limit OFFSET :offset
    """
    )
    suspend fun getFull(
        sortKey: String = DomainModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
        limit: Int,
        offset: Int,
        from: OffsetDateTime,
        to: OffsetDateTime,
    ): List<UserFullTransaction>

    @Query(
        """
        SELECT SUM(${UserTransaction.COLUMN_AMOUNT}) FROM ${UserTransaction.TABLE_NAME}
        WHERE (
            ${UserTransaction.COLUMN_TRANSACTION_TYPE} = :transactionType AND
            ${UserTransaction.COLUMN_DATETIME} >= :from AND
            ${UserTransaction.COLUMN_DATETIME} <= :to
        )
    """
    )
    suspend fun sumAmount(transactionType: TransactionType, from: OffsetDateTime, to: OffsetDateTime): Int?

    @Query("SELECT * FROM ${UserTransaction.TABLE_NAME} WHERE id = :id LIMIT 1")
    suspend fun getById(id: String): UserTransaction?

    @Query("DELETE FROM ${UserTransaction.TABLE_NAME} WHERE id = :id")
    suspend fun deleteById(id: String)
}