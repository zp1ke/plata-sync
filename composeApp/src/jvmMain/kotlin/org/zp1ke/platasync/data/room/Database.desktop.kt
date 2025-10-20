package org.zp1ke.platasync.data.room

import androidx.room.Room
import androidx.room.RoomDatabase
import org.koin.core.scope.Scope
import java.io.File

actual fun getDatabaseBuilder(scope: Scope): RoomDatabase.Builder<AppDatabase> {
    val appDataDir = getAppDataDirectory()
    if (!appDataDir.exists()) {
        appDataDir.mkdirs()
    }
    val dbFile = File(appDataDir, "plata_sync_room.db")
    return Room.databaseBuilder<AppDatabase>(
        name = dbFile.absolutePath,
    )
}

private fun getAppDataDirectory(): File {
    val os = System.getProperty("os.name").lowercase()
    val userHome = System.getProperty("user.home")

    return when {
        os.contains("win") -> {
            // Windows: use APPDATA or fallback to user.home
            val appData = System.getenv("APPDATA")
            if (appData != null) {
                File(appData, "plata-sync")
            } else {
                File(userHome, ".plata-sync")
            }
        }

        os.contains("mac") -> {
            // macOS: use Application Support
            File(userHome, "Library/Application Support/plata-sync")
        }

        else -> {
            // Linux and others: use hidden directory in home
            File(userHome, ".plata-sync")
        }
    }
}
