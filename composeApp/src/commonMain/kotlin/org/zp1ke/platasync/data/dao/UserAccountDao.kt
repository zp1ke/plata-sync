package org.zp1ke.platasync.data.dao

import androidx.room.Dao
import androidx.room.Query
import androidx.room.Upsert
import org.zp1ke.platasync.model.UserAccount

@Dao
interface UserAccountDao {
    @Upsert
    suspend fun save(item: UserAccount)

    @Query("SELECT * FROM ${UserAccount.TABLE_NAME}")
    suspend fun getAll(): List<UserAccount>

    @Query("SELECT * FROM ${UserAccount.TABLE_NAME} WHERE id = :id LIMIT 1")
    suspend fun getById(id: String): UserAccount?

    @Query("DELETE FROM ${UserAccount.TABLE_NAME} WHERE id = :id")
    suspend fun deleteById(id: String)
}
