package org.zp1ke.platasync.data.repository

import org.koin.core.annotation.Single
import org.zp1ke.platasync.data.dao.UserSettingsDao
import org.zp1ke.platasync.data.room.AppDatabase
import org.zp1ke.platasync.domain.UserSetting
import org.zp1ke.platasync.ui.common.ViewMode

@Single
class SettingsRepository(
    database: AppDatabase,
) {
    private val settingsDao: UserSettingsDao = database.getSettingsDao()

    suspend fun getViewMode(key: String): ViewMode {
        val setting = settingsDao.getSetting(key)
        return when (setting?.value) {
            UserSetting.VALUE_VIEW_MODE_LIST -> ViewMode.LIST
            UserSetting.VALUE_VIEW_MODE_GRID -> ViewMode.GRID
            else -> ViewMode.GRID // Default to GRID
        }
    }

    suspend fun saveViewMode(key: String, viewMode: ViewMode) {
        val value = when (viewMode) {
            ViewMode.LIST -> UserSetting.VALUE_VIEW_MODE_LIST
            ViewMode.GRID -> UserSetting.VALUE_VIEW_MODE_GRID
        }
        settingsDao.saveSetting(UserSetting(key, value))
    }
}
