package org.zp1ke.platasync.data.dao

import androidx.room.Dao
import androidx.room.Query
import androidx.room.Upsert
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.domain.BaseModel
import org.zp1ke.platasync.domain.UserCategory

@Dao
interface UserCategoryDao {
    @Upsert
    suspend fun save(item: UserCategory)

    @Query(
        """
        SELECT * FROM ${UserCategory.TABLE_NAME}
        WHERE (:nameFilter IS NULL OR ${UserCategory.COLUMN_NAME} LIKE '%' || :nameFilter || '%')
          AND (:transactionTypeFilter IS NULL OR ${UserCategory.COLUMN_TRANSACTION_TYPES} LIKE '%' || :transactionTypeFilter || '%')
        ORDER BY 
            CASE WHEN :sortOrder = '${SortOrder.ASC_VALUE}' THEN
                CASE :sortKey
                    WHEN '${BaseModel.COLUMN_CREATED_AT}' THEN ${BaseModel.COLUMN_CREATED_AT}
                    WHEN '${UserCategory.COLUMN_NAME}' THEN ${UserCategory.COLUMN_NAME}
                END
            END ASC,
            CASE WHEN :sortOrder = '${SortOrder.DESC_VALUE}' THEN
                CASE :sortKey
                    WHEN '${BaseModel.COLUMN_CREATED_AT}' THEN ${BaseModel.COLUMN_CREATED_AT}
                    WHEN '${UserCategory.COLUMN_NAME}' THEN ${UserCategory.COLUMN_NAME}
                END
            END DESC
    """
    )
    suspend fun getAll(
        nameFilter: String? = null,
        transactionTypeFilter: String? = null,
        sortKey: String = BaseModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
    ): List<UserCategory>

    @Query("SELECT * FROM ${UserCategory.TABLE_NAME} WHERE id = :id LIMIT 1")
    suspend fun getById(id: String): UserCategory?

    @Query("DELETE FROM ${UserCategory.TABLE_NAME} WHERE id = :id")
    suspend fun deleteById(id: String)
}
