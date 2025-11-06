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
import java.time.LocalTime
import java.time.OffsetDateTime

data class TransactionsScreenState(
    val screenState: ScreenState<UserFullTransaction>,
    val stats: BalanceStats,
    val from: OffsetDateTime,
    val to: OffsetDateTime,
) {
    val data: List<UserFullTransaction>
        get() = screenState.data

    val isLoading: Boolean
        get() = screenState.isLoading
}

class TransactionsViewModel(
    private val repository: TransactionsRepository,
    private val accountRepository: AccountsRepository,
    now: OffsetDateTime = OffsetDateTime.now(),
) : StateScreenModel<TransactionsScreenState>(
    TransactionsScreenState(
        screenState = ScreenState(
            data = listOf(),
            isLoading = false,
        ),
        stats = BalanceStats(),
        from = OffsetDateTime.of(now.toLocalDate().atStartOfDay(), now.offset),
        to = OffsetDateTime.of(now.toLocalDate().atTime(LocalTime.MAX), now.offset),
    ),
) {
    init {
        loadItems()
    }

    fun setRange(from: OffsetDateTime, to: OffsetDateTime) {
        mutableState.value = mutableState.value.copy(
            from = from,
            to = to,
        )
        loadItems()
    }

    fun loadItems(
        filters: Map<String, String> = emptyMap(),
        sortKey: String = DomainModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
    ) {
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
        screenModelScope.launch {
            val items = repository.getFull(sortKey, sortOrder, 1000, 0, mutableState.value.from, mutableState.value.to)
            val stats = repository.getBalanceStats(mutableState.value.from, mutableState.value.to)
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
