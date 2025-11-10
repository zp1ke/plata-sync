package org.zp1ke.platasync.data.dao

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import org.zp1ke.platasync.domain.UserSetting

@Dao
interface UserSettingsDao {
    @Query("SELECT * FROM ${UserSetting.TABLE_NAME} WHERE `key` = :key LIMIT 1")
    suspend fun getSetting(key: String): UserSetting?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun saveSetting(setting: UserSetting)

    @Query("DELETE FROM ${UserSetting.TABLE_NAME} WHERE `key` = :key")
    suspend fun deleteSetting(key: String)
}
