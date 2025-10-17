package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBalanceWallet
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.koin.compose.koinInject
import org.zp1ke.platasync.data.AccountRepository
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.common.LoadingIndicator
import org.zp1ke.platasync.ui.form.AccountEditDialog
import org.zp1ke.platasync.ui.screen.accounts.AccountDeleteDialog
import org.zp1ke.platasync.ui.screen.accounts.AccountsList
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.account_add
import platasync.composeapp.generated.resources.accounts_list
import platasync.composeapp.generated.resources.accounts_refresh

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

object AccountsScreen : Tab {

    override val options: TabOptions
        @Composable
        get() {
            val title = stringResource(Res.string.accounts_list)
            val icon = rememberVectorPainter(Icons.Filled.AccountBalanceWallet)

            return remember {
                TabOptions(
                    index = 0u,
                    title = title,
                    icon = icon,
                )
            }
        }

    @Composable
    override fun Content() {
        val repository: AccountRepository = koinInject()
        val viewModel = remember { AccountsScreenViewModel(repository) }
        val state by viewModel.state.collectAsState()

        var showAdd by remember { mutableStateOf(false) }
        var editAccount by remember { mutableStateOf<UserAccount?>(null) }
        var deleteAccount by remember { mutableStateOf<UserAccount?>(null) }

        AccountsListView(
            isLoading = state.isLoading,
            accounts = state.data,
            onReload = { viewModel.loadAccounts() },
            onView = { account -> print("Got account" + account.id) }, // TODO implement view
            onAdd = { showAdd = true },
            onEdit = { account -> editAccount = account },
            onDelete = { account -> deleteAccount = account },
        )

        AccountEditDialog(
            showDialog = showAdd || editAccount != null,
            account = editAccount,
            onDismiss = {
                showAdd = false
                editAccount = null
            },
            onSubmit = { account ->
                viewModel.addAccount(account)
                showAdd = false
                editAccount = null
            }
        )

        AccountDeleteDialog(
            showDialog = deleteAccount != null,
            account = deleteAccount,
            onDismiss = {
                deleteAccount = null
            },
            onSubmit = {
                viewModel.deleteAccount(deleteAccount!!)
                deleteAccount = null
            }
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
@Preview
private fun AccountsListView(
    isLoading: Boolean = false,
    accounts: List<UserAccount> = listOf(),
    onReload: () -> Unit = { },
    onAdd: () -> Unit = { },
    onView: (UserAccount) -> Unit = { _ -> },
    onEdit: (UserAccount) -> Unit = { _ -> },
    onDelete: (UserAccount) -> Unit = { _ -> },
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        stringResource(Res.string.accounts_list),
                        style = MaterialTheme.typography.titleMedium,
                    )
                },
                actions = {
                    if (isLoading) {
                        IconButton(onClick = { }, enabled = false) {
                            LoadingIndicator()
                        }
                    }
                    IconButton(onClick = { onReload() }) {
                        Icon(
                            imageVector = Icons.Filled.Refresh,
                            contentDescription = stringResource(Res.string.accounts_refresh),
                        )
                    }
                    IconButton(onClick = { onAdd() }) {
                        Icon(
                            imageVector = Icons.Filled.Add,
                            contentDescription = stringResource(Res.string.account_add),
                        )
                    }
                },
            )
        },
    ) { paddingValues ->
        Box(modifier = Modifier.padding(paddingValues)) {
            AccountsList(accounts, onView = onView, onEdit = onEdit, onDelete = onDelete)
        }
    }
}
