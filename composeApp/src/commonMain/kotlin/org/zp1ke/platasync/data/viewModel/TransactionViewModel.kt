package org.zp1ke.platasync.data.viewModel

import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import kotlinx.coroutines.launch
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.model.UserFullTransaction
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.data.repository.TransactionsRepository
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.domain.UserAccount
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.BalanceStats
import java.time.OffsetDateTime

class TransactionViewModel(
    private val repository: TransactionsRepository,
    private val accountRepository: BaseRepository<UserAccount>
) : StateScreenModel<ScreenState<UserFullTransaction>>(
    ScreenState(
        data = listOf(),
        stats = BalanceStats(),
        isLoading = false,
    ),
) {
    init {
        loadItems()
    }

    fun loadItems(
        filters: Map<String, String> = emptyMap(),
        sortKey: String = DomainModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
    ) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            val items = repository.getFull(sortKey, sortOrder, 1000, 0)
            val stats = repository.getBalanceStats()
            mutableState.value = ScreenState(
                data = items,
                stats = stats,
                isLoading = false,
            )
        }
    }

    fun saveItem(item: UserTransaction) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            repository.saveItem(item)
            val account = accountRepository.getItemById(item.accountId)
            if (account != null) {
                accountRepository.saveItem(
                    account.copy(
                        balance = item.accountBalanceAfter,
                        lastUsedAt = OffsetDateTime.now()
                    )
                )
            }
            val targetAccount = if (item.targetAccountId != null && item.targetAccountBalanceAfter != null) {
                accountRepository.getItemById(item.targetAccountId)
            } else {
                null
            }
            if (targetAccount != null) {
                accountRepository.saveItem(targetAccount.copy(balance = item.targetAccountBalanceAfter!!))
            }
            loadItems()
        }
    }

    fun deleteItem(item: UserTransaction) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            repository.deleteItem(item.id)
            val account = accountRepository.getItemById(item.accountId)
            if (account != null) {
                val accountBalanceBefore = account.balanceBefore(item.amount, item.transactionType)
                accountRepository.saveItem(account.copy(balance = accountBalanceBefore))
            }
            val targetAccount = if (item.targetAccountId != null && item.targetAccountBalanceAfter != null) {
                accountRepository.getItemById(item.targetAccountId)
            } else {
                null
            }
            if (targetAccount != null) {
                val accountBalanceBefore = targetAccount.balanceAfter(item.amount, item.transactionType)
                accountRepository.saveItem(targetAccount.copy(balance = accountBalanceBefore))
            }
            loadItems()
        }
    }
}
