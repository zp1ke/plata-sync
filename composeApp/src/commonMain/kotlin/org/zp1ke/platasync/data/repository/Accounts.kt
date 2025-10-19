package org.zp1ke.platasync.data.repository

import org.koin.core.annotation.Single
import org.zp1ke.platasync.data.dao.UserAccountDao
import org.zp1ke.platasync.data.room.AppDatabase
import org.zp1ke.platasync.model.UserAccount

@Single
class DaoAccountsRepository(
    database: AppDatabase,
) : BaseRepository<UserAccount> {
    private val accountDao: UserAccountDao = database.getAccountDao()

    override suspend fun getAllItems(): List<UserAccount> = accountDao.getAll()

    override suspend fun getItemById(id: String): UserAccount? = accountDao.getById(id)

    override suspend fun saveItem(item: UserAccount) = accountDao.save(item)

    override suspend fun deleteItem(id: String) = accountDao.deleteById(id)
}
