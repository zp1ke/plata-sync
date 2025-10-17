package org.zp1ke.platasync.data.repository

import org.zp1ke.platasync.model.BaseModel

interface BaseRepository<T : BaseModel> {
    suspend fun getAllItems(): List<T>
    suspend fun getItemById(id: String): T?
    suspend fun addItem(account: T)
    suspend fun updateItem(account: T)
    suspend fun deleteItem(id: String)
}
