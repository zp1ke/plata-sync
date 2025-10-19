package org.zp1ke.platasync.data.room

import androidx.room.TypeConverter
import org.zp1ke.platasync.ui.common.AppIcon

object Converters {
    @TypeConverter
    fun toAppIcon(value: String): AppIcon = enumValueOf<AppIcon>(value)

    @TypeConverter
    fun fromAppIcon(value: AppIcon): String = value.name
}