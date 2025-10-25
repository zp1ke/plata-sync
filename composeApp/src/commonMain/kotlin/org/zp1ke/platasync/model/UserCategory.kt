package org.zp1ke.platasync.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import org.zp1ke.platasync.ui.common.AppIcon
import java.time.OffsetDateTime

@Entity(tableName = UserCategory.TABLE_NAME)
data class UserCategory(
    @PrimaryKey
    override val id: String,
    @ColumnInfo(name = COLUMN_CREATED_AT)
    override val createdAt: OffsetDateTime,
    val name: String,
    val icon: AppIcon,
) : BaseModel(id, createdAt) {
    companion object {
        const val TABLE_NAME = "users_categories"

        const val COLUMN_NAME = "name"
    }
}
