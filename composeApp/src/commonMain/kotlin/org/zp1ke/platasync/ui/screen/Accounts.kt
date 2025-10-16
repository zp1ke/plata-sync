package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.DeleteForever
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
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
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.form.AccountDialog
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.formatAsMoney
import org.zp1ke.platasync.util.randomId
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.account_delete
import platasync.composeapp.generated.resources.account_edit

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
                    title = "ACC TODO",
                )
            }
        }

    @Composable
    override fun Content() {
        val viewModel = rememberScreenModel { AccountsScreenViewModel() }
        val state by viewModel.state.collectAsState()

        var showAdd by remember { mutableStateOf(false) }
        var editAccount by remember { mutableStateOf<UserAccount?>(null) }

        AccountsListView(
            accounts = state.data,
            onAdd = { showAdd = true },
            onEdit = { account -> editAccount = account },
            onDelete = { account -> viewModel.deleteAccount(account) }, // TODO confirmation dialog
        )

        AccountDialog(
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
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
@Preview
private fun AccountsListView(
    accounts: List<UserAccount> = listOf(
        UserAccount(randomId(), "Savings", AppIcon.ACCOUNT_PIGGY, 15000),
        UserAccount(randomId(), "Credit Card", AppIcon.ACCOUNT_CARD, 50000),
    ),
    onAdd: () -> Unit = { },
    onEdit: (UserAccount) -> Unit = { _ -> },
    onDelete: (UserAccount) -> Unit = { _ -> },
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text("TODO accounts", style = MaterialTheme.typography.titleMedium)
                },
                actions = {
                    IconButton(onClick = {
                        onAdd()
                    }) {
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
            AccountsList(accounts, onEdit = onEdit, onDelete = onDelete)
        }
    }
}

@Composable
private fun AccountsList(
    accounts: List<UserAccount>,
    onEdit: (UserAccount) -> Unit = { _ -> },
    onDelete: (UserAccount) -> Unit = { _ -> },
) {
    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(Spacing.small),
        modifier = Modifier.padding(horizontal = Spacing.small),
    ) {
        items(
            items = accounts,
            key = { it.id },
        ) { account ->
            AccountListItem(
                account = account,
                onEdit = { onEdit(account) },
                onDelete = { onDelete(account) },
            )
        }

        item {
            Spacer(Modifier.height(Spacing.medium))
        }
    }
}

@Composable
private fun AccountListItem(
    account: UserAccount,
    onEdit: () -> Unit = {},
    onDelete: () -> Unit = {},
) {
    ListItem(
        modifier = Modifier
            .clip(MaterialTheme.shapes.small)
            .padding(horizontal = Spacing.small),
        colors = ListItemDefaults.colors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        headlineContent = {
            Text(
                text = account.name,
                style = MaterialTheme.typography.titleMedium
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
            )
        },
        supportingContent = {
            Text(
                text = account.balance.formatAsMoney(),
                style = MaterialTheme.typography.bodySmall
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant, fontWeight = FontWeight.W500),
            )
        },
        leadingContent = {
            ImageIcon(account.icon)
        },
        trailingContent = {
            Row {
                IconButton(onClick = { onEdit() }) {
                    Icon(
                        imageVector = Icons.Filled.Edit,
                        contentDescription = stringResource(Res.string.account_edit),
                    )
                }
                IconButton(onClick = { onDelete() }) {
                    Icon(
                        imageVector = Icons.Filled.DeleteForever,
                        contentDescription = stringResource(Res.string.account_delete),
                    )
                }
            }
        },
    )
}
