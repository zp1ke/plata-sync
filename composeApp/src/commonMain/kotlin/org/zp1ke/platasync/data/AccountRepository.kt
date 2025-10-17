package org.zp1ke.platasync.data

import org.zp1ke.platasync.model.UserAccount

interface AccountRepository {
    suspend fun getAllAccounts(): List<UserAccount>
    suspend fun getAccountById(id: String): UserAccount?
    suspend fun addAccount(account: UserAccount)
    suspend fun updateAccount(account: UserAccount)
    suspend fun deleteAccount(id: String)
}
