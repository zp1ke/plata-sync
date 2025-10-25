package org.zp1ke.platasync.data.repository

import org.koin.core.annotation.Named
import org.koin.core.annotation.Single
import org.zp1ke.platasync.data.dao.SortOrder
import org.zp1ke.platasync.data.dao.UserCategoryDao
import org.zp1ke.platasync.data.room.AppDatabase
import org.zp1ke.platasync.model.BalanceStats
import org.zp1ke.platasync.model.UserCategory

@Single
@Named(DaoCategoriesRepository.KEY)
class DaoCategoriesRepository(
    database: AppDatabase,
) : BaseRepository<UserCategory> {
    private val categoryDao: UserCategoryDao = database.getCategoryDao()

    override suspend fun getAllItems(
        filters: Map<String, String>,
        sortKey: String,
        sortOrder: SortOrder,
    ): List<UserCategory> {
        var nameFilter: String? = null
        filters[UserCategory.COLUMN_NAME]?.let {
            nameFilter = it
        }
        return categoryDao.getAll(nameFilter, sortKey, sortOrder)
    }

    override suspend fun getBalanceStats(): BalanceStats = BalanceStats()

    override suspend fun getItemById(id: String): UserCategory? = categoryDao.getById(id)

    override suspend fun saveItem(item: UserCategory) = categoryDao.save(item)

    override suspend fun deleteItem(id: String) = categoryDao.deleteById(id)

    companion object {
        const val KEY = "categoriesRepository"
    }
}
