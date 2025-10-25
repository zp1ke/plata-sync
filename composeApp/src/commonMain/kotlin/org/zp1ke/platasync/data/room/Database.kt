package org.zp1ke.platasync.data.room

import androidx.room.*
import androidx.sqlite.driver.bundled.BundledSQLiteDriver
import kotlinx.coroutines.Dispatchers
import org.koin.core.annotation.Single
import org.koin.core.scope.Scope
import org.zp1ke.platasync.data.dao.UserAccountDao
import org.zp1ke.platasync.data.dao.UserCategoryDao
import org.zp1ke.platasync.model.UserAccount

@Database(entities = [UserAccount::class], version = 1)
@ConstructedBy(AppDatabaseConstructor::class)
@TypeConverters(Converters::class)
abstract class AppDatabase() : RoomDatabase() {
    abstract fun getAccountDao(): UserAccountDao
    abstract fun getCategoryDao(): UserCategoryDao
}

@Single
fun createDatabase(
    scope: Scope,
): AppDatabase {
    return getDatabaseBuilder(scope)
        .setDriver(BundledSQLiteDriver())
        .setQueryCoroutineContext(Dispatchers.IO)
        .build()
}

expect fun getDatabaseBuilder(scope: Scope): RoomDatabase.Builder<AppDatabase>

@Suppress("KotlinNoActualForExpect")
expect object AppDatabaseConstructor : RoomDatabaseConstructor<AppDatabase> {
    override fun initialize(): AppDatabase
}


