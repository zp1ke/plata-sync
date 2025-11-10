package org.zp1ke.platasync.domain

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = UserSetting.TABLE_NAME)
data class UserSetting(
    @PrimaryKey
    val key: String,
    val value: String,
) {
    companion object {
        const val TABLE_NAME = "user_settings"

        const val KEY_VIEW_MODE_ACCOUNTS = "view_mode_accounts"
        const val KEY_VIEW_MODE_CATEGORIES = "view_mode_categories"
        const val KEY_VIEW_MODE_TRANSACTIONS = "view_mode_transactions"

        const val VALUE_VIEW_MODE_LIST = "LIST"
        const val VALUE_VIEW_MODE_GRID = "GRID"
    }
}

