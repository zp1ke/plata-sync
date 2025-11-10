package org.zp1ke.platasync.data.viewModel

import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import kotlinx.coroutines.launch
import org.zp1ke.platasync.data.model.ScreenState
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.repository.CategoriesRepository
import org.zp1ke.platasync.domain.UserCategory

data class CategoriesScreenState(
    val screenState: ScreenState<UserCategory>,
) {
    val data: List<UserCategory>
        get() = screenState.data

    val isLoading: Boolean
        get() = screenState.isLoading
}

class CategoriesViewModel(
    private val repository: CategoriesRepository,
) : StateScreenModel<CategoriesScreenState>(
    CategoriesScreenState(
        screenState = ScreenState(
            data = listOf(),
            isLoading = false,
        ),
    ),
) {
    init {
        loadItems()
    }

    fun loadItems(
        filters: Map<String, String> = emptyMap(),
        sortKey: String = UserCategory.COLUMN_LAST_USED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
    ) {
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
        screenModelScope.launch {
            val items = repository.getAllItems(filters, sortKey, sortOrder)
            mutableState.value = mutableState.value.copy(
                screenState = ScreenState(
                    data = items,
                    isLoading = false,
                ),
            )
        }
    }

    fun saveItem(item: UserCategory) {
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
        screenModelScope.launch {
            repository.saveItem(item)
            loadItems()
        }
    }

    fun deleteItem(item: UserCategory) {
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
        screenModelScope.launch {
            repository.deleteItem(item.id)
            loadItems()
        }
    }
}
