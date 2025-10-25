package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.fillMaxWidth
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
import androidx.compose.ui.text.style.TextAlign
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import org.jetbrains.compose.resources.stringResource
import org.koin.core.annotation.Factory
import org.koin.core.annotation.Named
import org.zp1ke.platasync.data.dao.SortOrder
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.data.repository.DaoAccountsRepository
import org.zp1ke.platasync.data.viewModel.BaseViewModel
import org.zp1ke.platasync.model.BaseModel
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.common.BaseList
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.screen.accounts.AccountDeleteDialog
import org.zp1ke.platasync.ui.screen.accounts.AccountEditDialog
import org.zp1ke.platasync.ui.screen.accounts.AccountsFilterWidget
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.util.formatAsMoney
import platasync.composeapp.generated.resources.*

@Factory
class AccountsScreen(
    @Named(DaoAccountsRepository.KEY) repository: BaseRepository<UserAccount>,
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

        var accountToEdit by remember { mutableStateOf<UserAccount?>(null) }
        var showEditDialog by remember { mutableStateOf(false) }
        var accountToDelete by remember { mutableStateOf<UserAccount?>(null) }

        val itemActions = object : ItemActions<UserAccount> {
            override fun onView(item: UserAccount) {
                // TODO implement view
            }

            override fun onEdit(item: UserAccount) {
                accountToEdit = item
                showEditDialog = true
            }

            override fun onDelete(item: UserAccount) {
                accountToDelete = item
            }
        }

        var filterVisible by remember { mutableStateOf(false) }
        var filterName by remember { mutableStateOf("") }
        var sortField by remember { mutableStateOf(BaseModel.COLUMN_CREATED_AT) }
        var sortOrder by remember { mutableStateOf(SortOrder.DESC) }
        var reloadTrigger by remember { mutableIntStateOf(0) }

        // Trigger loadData whenever filter/sort parameters change or reload is requested
        LaunchedEffect(filterName, sortField, sortOrder, reloadTrigger) {
            val filters = mutableMapOf<String, String>()
            val trimmedFilterName = filterName.trim()
            if (trimmedFilterName.isNotBlank()) {
                filters[UserAccount.COLUMN_NAME] = trimmedFilterName
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
                    onClick = {
                        @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                        filterVisible = !filterVisible
                    },
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
                            onFilterNameChange = { filterName = it },
                            sortField = sortField,
                            onSortFieldChange = { sortField = it },
                            sortOrder = sortOrder,
                            onSortOrderChange = { sortOrder = it },
                        )
                    }
                }
                return null
            }
        }

        BaseScreen(
            isLoading = state.isLoading,
            onReload = { reloadTrigger++ },
            onAdd = {
                accountToEdit = null
                showEditDialog = true
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
                                text = account.balance.formatAsMoney(),
                                style = MaterialTheme.typography.bodySmall
                                    .copy(
                                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                                        fontWeight = FontWeight.W500
                                    ),
                                modifier = Modifier.fillMaxWidth(0.25f),
                                textAlign = TextAlign.End
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
            showDialog = showEditDialog,
            account = accountToEdit,
            onDismiss = {
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                showEditDialog = false
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                accountToEdit = null
            },
            onSubmit = { account ->
                viewModel.addItem(account)
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                showEditDialog = false
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                accountToEdit = null
                reloadTrigger++
            }
        )

        AccountDeleteDialog(
            showDialog = accountToDelete != null,
            account = accountToDelete,
            onDismiss = {
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                accountToDelete = null
            },
            onSubmit = {
                accountToDelete?.let { viewModel.deleteItem(it) }
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                accountToDelete = null
                reloadTrigger++
            }
        )
    }
}
