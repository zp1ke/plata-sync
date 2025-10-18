package org.zp1ke.platasync.data.repository

import kotlinx.coroutines.delay
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.common.AppIcon
import org.zp1ke.platasync.util.randomId

class DummyAccountsRepository : BaseRepository<UserAccount> {
    private val accounts = mutableListOf<UserAccount>()

    init {
        // Initialize with some dummy data
        accounts.addAll(
            listOf(
                UserAccount(
                    id = randomId(),
                    name = "Savings",
                    icon = AppIcon.ACCOUNT_PIGGY,
                    balance = 15000,
                ),
                UserAccount(
                    id = randomId(),
                    name = "Credit Card",
                    icon = AppIcon.ACCOUNT_CARD,
                    balance = 50000,
                ),
                UserAccount(
                    id = randomId(),
                    name = "Checking Account",
                    icon = AppIcon.ACCOUNT_BANK,
                    balance = 25000,
                ),
            )
        )
    }

    override suspend fun getAllItems(): List<UserAccount> {
        delay(500) // Simulate network delay
        return accounts.toList()
    }

    override suspend fun getItemById(id: String): UserAccount? {
        delay(300) // Simulate network delay
        return accounts.firstOrNull { it.id == id }
    }

    override suspend fun addItem(item: UserAccount) {
        delay(400) // Simulate network delay
        accounts.add(item)
    }

    override suspend fun updateItem(item: UserAccount) {
        delay(400) // Simulate network delay
        val index = accounts.indexOfFirst { it.id == item.id }
        if (index >= 0) {
            accounts[index] = item
        }
    }

    override suspend fun deleteItem(id: String) {
        delay(400) // Simulate network delay
        accounts.removeAll { it.id == id }
    }
}

