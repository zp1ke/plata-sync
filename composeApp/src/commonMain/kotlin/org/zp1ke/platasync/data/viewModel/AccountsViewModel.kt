package org.zp1ke.platasync.data.viewModel

import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import kotlinx.coroutines.launch
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.repository.AccountsRepository
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.domain.UserAccount
import org.zp1ke.platasync.model.BalanceStats

data class AccountsScreenState(
    val screenState: ScreenState<UserAccount>,
    val stats: BalanceStats,
) {
    val data: List<UserAccount>
        get() = screenState.data

    val isLoading: Boolean
        get() = screenState.isLoading
}

class AccountsViewModel(
    private val repository: AccountsRepository,
) : StateScreenModel<AccountsScreenState>(
    AccountsScreenState(
        screenState = ScreenState(
            data = listOf(),
            isLoading = false,
        ),
        stats = BalanceStats(),
    ),
) {
    init {
        loadItems()
    }

    fun loadItems(
        filters: Map<String, String> = emptyMap(),
        sortKey: String = UserAccount.COLUMN_LAST_USED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
    ) {
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
        screenModelScope.launch {
            val items = repository.getAllItems(filters, sortKey, sortOrder)
            val stats = repository.getBalanceStats()
            mutableState.value = mutableState.value.copy(
                screenState = ScreenState(
                    data = items,
                    isLoading = false,
                ),
                stats = stats,
            )
        }
    }

    fun saveItem(item: UserAccount) {
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
        screenModelScope.launch {
            repository.saveItem(item)
            loadItems()
        }
    }

    fun deleteItem(item: UserAccount) {
        mutableState.value = mutableState.value.copy(
            screenState = mutableState.value.screenState.copy(isLoading = true)
        )
        screenModelScope.launch {
            repository.deleteItem(item.id)
            loadItems()
        }
    }
}
