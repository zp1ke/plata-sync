package org.zp1ke.platasync.data.room

import android.content.Context
import androidx.room.Room
import androidx.room.RoomDatabase
import org.koin.core.scope.Scope

actual fun getDatabaseBuilder(scope: Scope): RoomDatabase.Builder<AppDatabase> {
    val context: Context = scope.get()
    val appContext = context.applicationContext
    val dbFile = appContext.getDatabasePath("plata_sync_room.db")
    return Room.databaseBuilder<AppDatabase>(
        context = appContext,
        name = dbFile.absolutePath
    )
}
