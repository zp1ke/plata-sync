package org.zp1ke.platasync.data.viewModel

import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import kotlinx.coroutines.launch
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.model.BalanceStats
import org.zp1ke.platasync.domain.BaseModel

data class ScreenState<T : BaseModel>(
    val data: List<T>,
    val stats: BalanceStats,
    val isLoading: Boolean,
)

class BaseViewModel<T : BaseModel>(
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
        sortKey: String = BaseModel.COLUMN_CREATED_AT,
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

    fun addItem(item: T) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            repository.saveItem(item)
            loadItems()
        }
    }

    fun deleteItem(item: T) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            repository.deleteItem(item.id)
            loadItems()
        }
    }
}
