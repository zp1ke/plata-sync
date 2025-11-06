package org.zp1ke.platasync.data.repository

import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.domain.DomainModel

interface BaseRepository<T : DomainModel> {
    suspend fun getAllItems(
        filters: Map<String, String> = emptyMap(),
        sortKey: String = DomainModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
    ): List<T>

    suspend fun getItemById(id: String): T?
    suspend fun saveItem(item: T)
    suspend fun deleteItem(id: String)
}
