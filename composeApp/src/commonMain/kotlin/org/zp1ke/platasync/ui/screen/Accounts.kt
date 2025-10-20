package org.zp1ke.platasync.ui.screen

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBalanceWallet
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import androidx.compose.ui.text.font.FontWeight
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import org.jetbrains.compose.resources.stringResource
import org.koin.core.annotation.Factory
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.data.viewModel.BaseViewModel
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.common.BaseList
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.form.AccountEditDialog
import org.zp1ke.platasync.ui.screen.accounts.AccountDeleteDialog
import org.zp1ke.platasync.util.formatAsMoney
import platasync.composeapp.generated.resources.*

@Factory
class AccountsScreen(
    repository: BaseRepository<UserAccount>,
) : Tab {
    private val screenViewModel: BaseViewModel<UserAccount> = BaseViewModel(repository)

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
        val viewModel = remember { screenViewModel }
        val state by viewModel.state.collectAsState()

        var showAdd by remember { mutableStateOf(false) }
        var editAccount by remember { mutableStateOf<UserAccount?>(null) }
        var deleteAccount by remember { mutableStateOf<UserAccount?>(null) }

        val itemActions = object : ItemActions<UserAccount> {
            override fun onView(item: UserAccount) {
                // TODO implement view
            }

            override fun onEdit(item: UserAccount) {
                editAccount = item
            }

            override fun onDelete(item: UserAccount) {
                deleteAccount = item
            }
        }

        BaseScreen(
            isLoading = state.isLoading,
            onReload = { viewModel.loadItems() },
            onAdd = {
                editAccount = null
                showAdd = true
            },
            actions = itemActions,
            titleResource = Res.string.accounts_list,
            refreshResource = Res.string.accounts_refresh,
            addResource = Res.string.account_add,
            list = { enabled, actions ->
                BaseList(
                    items = state.data,
                    actions = actions,
                    enabled = enabled,
                    emptyStringResource = Res.string.accounts_empty,
                    editStringResource = Res.string.account_edit,
                    deleteStringResource = Res.string.account_delete,
                    headlineContent = { account ->
                        {
                            Text(
                                text = account.name,
                                style = MaterialTheme.typography.titleMedium
                                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                            )
                        }
                    },
                    supportingContent = { account ->
                        {
                            Text(
                                text = account.initialBalance.formatAsMoney(),
                                style = MaterialTheme.typography.bodySmall
                                    .copy(
                                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                                        fontWeight = FontWeight.W500
                                    ),
                            )
                        }
                    },
                    leadingContent = { account ->
                        {
                            ImageIcon(account.icon)
                        }
                    },
                )
            }
        )

        AccountEditDialog(
            showDialog = showAdd || editAccount != null,
            account = editAccount,
            onDismiss = {
                showAdd = false
                editAccount = null
            },
            onSubmit = { account ->
                viewModel.addItem(account)
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
                viewModel.deleteItem(deleteAccount!!)
                deleteAccount = null
            }
        )
    }
}
