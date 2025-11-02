package org.zp1ke.platasync.data.viewModel

import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import kotlinx.coroutines.launch
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.model.BalanceStats

data class ScreenState<T : DomainModel>(
    val data: List<T>,
    val stats: BalanceStats,
    val isLoading: Boolean,
)

class BaseViewModel<T : DomainModel>(
    private val repository: BaseRepository<T>
) : StateScreenModel<ScreenState<T>>(
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
            val items = repository.getAllItems(filters, sortKey, sortOrder)
            val stats = repository.getBalanceStats()
            mutableState.value = ScreenState(
                data = items,
                stats = stats,
                isLoading = false,
            )
        }
    }

    fun saveItem(item: T) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            repository.saveItem(item)
            loadItems()
        }
    }

    fun deleteItem(item: T) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            repository.deleteItem(item.id())
            loadItems()
        }
    }
}
