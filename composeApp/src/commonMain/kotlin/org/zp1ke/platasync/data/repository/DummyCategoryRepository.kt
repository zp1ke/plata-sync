package org.zp1ke.platasync.data

import kotlinx.coroutines.delay
import org.zp1ke.platasync.model.AppIcon
import org.zp1ke.platasync.model.UserCategory
import org.zp1ke.platasync.util.randomId

class DummyCategoryRepository : CategoryRepository {
    private val categories = mutableListOf<UserCategory>()

    init {
        // Initialize with some dummy data
        categories.addAll(
            listOf(
                UserCategory(
                    id = randomId(),
                    name = "Home",
                    icon = AppIcon.CATEGORY_HOME,
                ),
                UserCategory(
                    id = randomId(),
                    name = "Groceries",
                    icon = AppIcon.CATEGORY_GROCERIES,
                ),
            )
        )
    }

    override suspend fun getAllCategories(): List<UserCategory> {
        delay(500) // Simulate network delay
        return categories.toList()
    }

    override suspend fun getCategoryById(id: String): UserCategory? {
        delay(300) // Simulate network delay
        return categories.firstOrNull { it.id == id }
    }

    override suspend fun addCategory(category: UserCategory) {
        delay(400) // Simulate network delay
        categories.add(category)
    }

    override suspend fun updateCategory(category: UserCategory) {
        delay(400) // Simulate network delay
        val index = categories.indexOfFirst { it.id == category.id }
        if (index >= 0) {
            categories[index] = category
        }
    }

    override suspend fun deleteCategory(id: String) {
        delay(400) // Simulate network delay
        categories.removeAll { it.id == id }
    }
}
