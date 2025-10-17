package org.zp1ke.platasync.data

import org.zp1ke.platasync.model.UserCategory

interface CategoryRepository {
    suspend fun getAllCategories(): List<UserCategory>
    suspend fun getCategoryById(id: String): UserCategory?
    suspend fun addCategory(category: UserCategory)
    suspend fun updateCategory(category: UserCategory)
    suspend fun deleteCategory(id: String)
}
