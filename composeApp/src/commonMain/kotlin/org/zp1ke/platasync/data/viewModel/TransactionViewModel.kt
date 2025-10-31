package org.zp1ke.platasync.data.viewModel

import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import kotlinx.coroutines.launch
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.model.UserFullTransaction
import org.zp1ke.platasync.data.repository.TransactionsRepository
import org.zp1ke.platasync.domain.BaseModel
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.BalanceStats

class TransactionViewModel(
    private val repository: TransactionsRepository
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
        sortKey: String = BaseModel.COLUMN_CREATED_AT,
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

    fun addItem(item: UserTransaction) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            repository.saveItem(item)
            loadItems()
        }
    }

    fun deleteItem(item: UserTransaction) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            repository.deleteItem(item.id)
            loadItems()
        }
    }
}
