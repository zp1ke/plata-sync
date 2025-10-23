package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBalanceWallet
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.outlined.FilterListOff
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import androidx.compose.ui.text.font.FontWeight
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import org.jetbrains.compose.resources.stringResource
import org.koin.core.annotation.Factory
import org.zp1ke.platasync.data.dao.SortOrder
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.data.viewModel.BaseViewModel
import org.zp1ke.platasync.model.BaseModel
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.common.BaseList
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.form.AccountEditDialog
import org.zp1ke.platasync.ui.screen.accounts.AccountDeleteDialog
import org.zp1ke.platasync.ui.screen.accounts.AccountsFilterWidget
import org.zp1ke.platasync.ui.theme.Size
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

        var filterVisible by remember { mutableStateOf(false) }
        var filterName by remember { mutableStateOf("") }
        var sortField by remember { mutableStateOf(BaseModel.COLUMN_CREATED_AT) }
        var sortOrder by remember { mutableStateOf(SortOrder.DESC) }

        fun loadData() {
            val filters = mutableMapOf<String, String>()
            if (filterName.isNotBlank()) {
                filters[UserAccount.COLUMN_NAME] = filterName
            }
            viewModel.loadItems(
                filters = filters,
                sortKey = sortField,
                sortOrder = sortOrder,
            )
        }

        val filterWidgetProvider = object : TopWidgetProvider {
            override fun action(): (@Composable () -> Unit) = {
                var buttonColor = Color.Unspecified
                var iconColor = Color.Unspecified
                val isFiltered =
                    filterName.isNotBlank() || sortField != BaseModel.COLUMN_CREATED_AT || sortOrder != SortOrder.DESC
                if (!filterVisible && isFiltered) {
                    buttonColor = MaterialTheme.colorScheme.errorContainer // TODO: warning color
                    iconColor = MaterialTheme.colorScheme.onErrorContainer // TODO: warning color
                }
                IconButton(
                    onClick = { filterVisible = !filterVisible },
                    enabled = !state.isLoading,
                    colors = IconButtonDefaults.iconButtonColors(
                        containerColor = buttonColor
                    )
                ) {
                    Icon(
                        imageVector = if (filterVisible) Icons.Outlined.FilterListOff else Icons.Filled.FilterList,
                        tint = iconColor,
                        contentDescription = null,
                    )
                }
            }

            override fun content(): (@Composable () -> Unit)? {
                if (filterVisible) {
                    return {
                        AccountsFilterWidget(
                            enabled = !state.isLoading,
                            filterName = filterName,
                            onFilterNameChange = {
                                filterName = it.trim()
                                loadData()
                            },
                            sortField = sortField,
                            onSortFieldChange = {
                                sortField = it
                                loadData()
                            },
                            sortOrder = sortOrder,
                            onSortOrderChange = {
                                sortOrder = it
                                loadData()
                            }
                        )
                    }
                }
                return null
            }
        }

        BaseScreen(
            isLoading = state.isLoading,
            onReload = { loadData() },
            onAdd = {
                editAccount = null
                showAdd = true
            },
            actions = itemActions,
            titleIcon = {
                Icon(
                    imageVector = Icons.Filled.AccountBalanceWallet,
                    contentDescription = stringResource(Res.string.accounts_list),
                    modifier = Modifier.width(Size.iconSmall),
                )
            },
            titleResource = Res.string.accounts_list,
            subtitle = state.stats.balance.formatAsMoney(),
            refreshResource = Res.string.accounts_refresh,
            addResource = Res.string.account_add,
            topWidgetProvider = filterWidgetProvider,
            list = { enabled, actions ->
                BaseList(
                    items = state.data,
                    actions = actions,
                    enabled = enabled,
                    emptyStringResource = if (filterName.isBlank()) Res.string.accounts_empty else Res.string.accounts_empty_with_filter,
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
