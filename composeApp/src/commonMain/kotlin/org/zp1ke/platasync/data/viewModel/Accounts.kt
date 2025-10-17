package org.zp1ke.platasync.data.viewModel

import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import kotlinx.coroutines.launch
import org.zp1ke.platasync.data.AccountRepository
import org.zp1ke.platasync.model.UserAccount

data class AccountsScreenState(
    val data: List<UserAccount>,
    val isLoading: Boolean,
)

class AccountsScreenViewModel(
    private val repository: AccountRepository
) : StateScreenModel<AccountsScreenState>(
    AccountsScreenState(
        data = listOf(),
        isLoading = false,
    ),
) {
    init {
        loadAccounts()
    }

    fun loadAccounts() {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            val accounts = repository.getAllAccounts()
            mutableState.value = AccountsScreenState(
                data = accounts,
                isLoading = false,
            )
        }
    }

    fun addAccount(account: UserAccount) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            val index = mutableState.value.data.indexOfFirst { it.id == account.id }
            if (index >= 0) {
                // Update existing
                repository.updateAccount(account)
            } else {
                repository.addAccount(account)
            }
            loadAccounts()
        }
    }

    fun deleteAccount(account: UserAccount) {
        mutableState.value = mutableState.value.copy(isLoading = true)
        screenModelScope.launch {
            repository.deleteAccount(account.id)
            loadAccounts()
        }
    }
}
