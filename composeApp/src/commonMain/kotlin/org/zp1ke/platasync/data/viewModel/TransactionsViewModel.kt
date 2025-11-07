package org.zp1ke.platasync.data.viewModel

import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import kotlinx.coroutines.launch
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.model.UserFullTransaction
import org.zp1ke.platasync.data.repository.AccountsRepository
import org.zp1ke.platasync.data.repository.TransactionsRepository
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.BalanceStats
import org.zp1ke.platasync.model.DateRangePreset
import java.time.OffsetDateTime

data class TransactionsScreenState(
    val screenState: ScreenState<UserFullTransaction>,
    val stats: BalanceStats,
    val dateRange: DateRangePreset,
) {
    val data: List<UserFullTransaction>
        get() = screenState.data

    val isLoading: Boolean
        get() = screenState.isLoading
}

class TransactionsViewModel(
    private val repository: TransactionsRepository,
    private val accountRepository: AccountsRepository,
) : StateScreenModel<TransactionsScreenState>(
    TransactionsScreenState(
        screenState = ScreenState(
            data = listOf(),
            isLoading = false,
        ),
        stats = BalanceStats(),
        dateRange = DateRangePreset.TODAY,
    ),
) {
    init {
        loadItems()
    }

    fun setRange(dateRange: DateRangePreset) {
        mutableState.value = mutableState.value.copy(
            dateRange = dateRange,
        )
        loadItems()
    }

    fun loadItems(
        sortKey: String = DomainModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
        accountId: String? = null,
        categoryId: String? = null,
    ) {
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
        screenModelScope.launch {
            val from = mutableState.value.dateRange.getDateRange().first
            val to = mutableState.value.dateRange.getDateRange().second
            val items = repository.getFull(sortKey, sortOrder, 1000, 0, from, to, accountId, categoryId)
            val stats = repository.getBalanceStats(from, to, accountId, categoryId)
            mutableState.value = mutableState.value.copy(
                screenState = ScreenState(
                    data = items,
                    isLoading = false,
                ),
                stats = stats,
            )
        }
    }

    fun saveItem(item: UserTransaction) {
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
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
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
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
