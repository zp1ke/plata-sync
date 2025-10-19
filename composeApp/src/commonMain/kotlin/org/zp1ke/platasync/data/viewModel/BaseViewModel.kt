package org.zp1ke.platasync.data.viewModel

import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import kotlinx.coroutines.launch
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.model.BaseModel

data class ScreenState<T : BaseModel>(
    val data: List<T>,
    val isLoading: Boolean,
)

class BaseViewModel<T : BaseModel>(
    private val repository: BaseRepository<T>
) : StateScreenModel<ScreenState<T>>(
    ScreenState(
        data = listOf(),
        isLoading = false,
    ),
) {
    init {
        loadItems()
    }

    fun loadItems() {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            val items = repository.getAllItems()
            mutableState.value = ScreenState(
                data = items,
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
