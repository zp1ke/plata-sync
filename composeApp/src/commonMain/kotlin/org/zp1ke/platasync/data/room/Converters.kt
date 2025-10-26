package org.zp1ke.platasync.data.room

import androidx.room.TypeConverter
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.AppIcon
import java.time.Instant
import java.time.OffsetDateTime


object Converters {
    @TypeConverter
    fun toAppIcon(value: String): AppIcon = enumValueOf<AppIcon>(value)

    @TypeConverter
    fun fromAppIcon(value: AppIcon): String = value.name

    @TypeConverter
    fun toInstant(value: Long): OffsetDateTime = OffsetDateTime
        .ofInstant(Instant.ofEpochMilli(value), OffsetDateTime.now().offset)

    @TypeConverter
    fun fromInstant(value: OffsetDateTime): Long = value.toInstant().toEpochMilli()

    @TypeConverter
    fun fromTransactionTypeList(list: List<TransactionType>?): String {
        if (list.isNullOrEmpty()) {
            return ""
        }
        return list.joinToString(",") { it.name }
    }

    @TypeConverter
    fun toTransactionTypeList(value: String?): List<TransactionType> {
        if (value.isNullOrBlank()) {
            return emptyList()
        }
        return value.split(",")
            .filter { it.isNotBlank() }
            .map { enumValueOf<TransactionType>(it.trim()) }
    }
}
