package org.zp1ke.platasync.data.repository

import org.zp1ke.platasync.data.dao.SortOrder
import org.zp1ke.platasync.model.BalanceStats
import org.zp1ke.platasync.model.BaseModel

interface BaseRepository<T : BaseModel> {
    suspend fun getAllItems(
        sortKey: String = BaseModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
    ): List<T>

    suspend fun getBalanceStats(): BalanceStats
    suspend fun getItemById(id: String): T?
    suspend fun saveItem(item: T)
    suspend fun deleteItem(id: String)
}
