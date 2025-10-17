package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.rememberScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.AppIcon
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.form.AccountEditDialog
import org.zp1ke.platasync.ui.screen.accounts.AccountDeleteDialog
import org.zp1ke.platasync.ui.screen.accounts.AccountsList
import org.zp1ke.platasync.util.randomId
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.account_list

data class AccountsScreenState(
    val data: List<UserAccount>,
)

class AccountsScreenViewModel : StateScreenModel<AccountsScreenState>(
    AccountsScreenState(
        data = listOf(),
    ),
) {
    init {
        screenModelScope.launch {
            delay(300)
            mutableState.value = AccountsScreenState(
                data = listOf(
                    UserAccount(
                        id = randomId(),
                        name = "Savings",
                        icon = AppIcon.ACCOUNT_PIGGY,
                        balance = 15000,
                    ),
                    UserAccount(
                        id = randomId(),
                        name = "Credit Card",
                        icon = AppIcon.ACCOUNT_CARD,
                        balance = 50000,
                    ),
                )
            )
        }
    }

    fun addAccount(account: UserAccount) {
        val index = mutableState.value.data.indexOfFirst { it.id == account.id }
        if (index >= 0) {
            // Update existing
            mutableState.value = AccountsScreenState(
                data = mutableState.value.data.toMutableList().also {
                    it[index] = account
                }
            )
        } else {
            mutableState.value = AccountsScreenState(
                data = mutableState.value.data + account
            )
        }
    }

    fun deleteAccount(account: UserAccount) {
        mutableState.value = AccountsScreenState(
            data = mutableState.value.data.filter { it.id != account.id }
        )
    }
}

object AccountsScreen : Tab {

    override val options: TabOptions
        @Composable
        get() {
            return remember {
                TabOptions(
                    index = 0u,
                    title = "ACC TODO", // TODO string resource
                    icon = null, // TODO provide icon
                )
            }
        }

    @Composable
    override fun Content() {
        val viewModel = rememberScreenModel { AccountsScreenViewModel() }
        val state by viewModel.state.collectAsState()

        var showAdd by remember { mutableStateOf(false) }
        var editAccount by remember { mutableStateOf<UserAccount?>(null) }
        var deleteAccount by remember { mutableStateOf<UserAccount?>(null) }

        AccountsListView(
            accounts = state.data,
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
    accounts: List<UserAccount>,
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
                        stringResource(Res.string.account_list),
                        style = MaterialTheme.typography.titleMedium,
                    )
                },
                actions = {
                    IconButton(onClick = { onAdd() }) {
                        Icon(
                            imageVector = Icons.Filled.Add,
                            contentDescription = "Add Account",
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
