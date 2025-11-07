package org.zp1ke.platasync.data.dao

import androidx.room.Dao
import androidx.room.Query
import androidx.room.Upsert
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.domain.UserAccount

@Dao
interface UserAccountDao {
    @Upsert
    suspend fun save(item: UserAccount)

    @Query(
        """
        SELECT * FROM ${UserAccount.TABLE_NAME}
        WHERE (:nameFilter IS NULL OR ${UserAccount.COLUMN_NAME} LIKE '%' || :nameFilter || '%')
        ORDER BY 
            CASE WHEN :sortOrder = '${SortOrder.ASC_VALUE}' THEN
                CASE :sortKey
                    WHEN '${UserAccount.COLUMN_LAST_USED_AT}' THEN ${UserAccount.COLUMN_LAST_USED_AT}
                    WHEN '${DomainModel.COLUMN_CREATED_AT}' THEN ${DomainModel.COLUMN_CREATED_AT}
                    WHEN '${UserAccount.COLUMN_NAME}' THEN ${UserAccount.COLUMN_NAME}
                    WHEN '${UserAccount.COLUMN_BALANCE}' THEN ${UserAccount.COLUMN_BALANCE}
                END
            END ASC,
            CASE WHEN :sortOrder = '${SortOrder.DESC_VALUE}' THEN
                CASE :sortKey
                    WHEN '${UserAccount.COLUMN_LAST_USED_AT}' THEN ${UserAccount.COLUMN_LAST_USED_AT}
                    WHEN '${DomainModel.COLUMN_CREATED_AT}' THEN ${DomainModel.COLUMN_CREATED_AT}
                    WHEN '${UserAccount.COLUMN_NAME}' THEN ${UserAccount.COLUMN_NAME}
                    WHEN '${UserAccount.COLUMN_BALANCE}' THEN ${UserAccount.COLUMN_BALANCE}
                END
            END DESC
    """
    )
    suspend fun getAll(
        nameFilter: String? = null,
        sortKey: String = UserAccount.COLUMN_LAST_USED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
    ): List<UserAccount>

    @Query("SELECT SUM(${UserAccount.COLUMN_BALANCE}) FROM ${UserAccount.TABLE_NAME}")
    suspend fun sumBalance(): Int?

    @Query("SELECT * FROM ${UserAccount.TABLE_NAME} WHERE id = :id LIMIT 1")
    suspend fun getById(id: String): UserAccount?

    @Query("DELETE FROM ${UserAccount.TABLE_NAME} WHERE id = :id")
    suspend fun deleteById(id: String)
}
