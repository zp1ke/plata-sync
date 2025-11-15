package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.filled.Receipt
import androidx.compose.material.icons.outlined.FilterListOff
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.stringResource
import org.koin.core.annotation.Factory
import org.koin.core.annotation.Named
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.model.UserFullTransaction
import org.zp1ke.platasync.data.repository.*
import org.zp1ke.platasync.data.viewModel.TransactionsViewModel
import org.zp1ke.platasync.domain.UserSetting
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.BaseList
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.common.ViewMode
import org.zp1ke.platasync.ui.common.ViewModeToggle
import org.zp1ke.platasync.ui.feature.transactions.*
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.formatAsMoney
import platasync.composeapp.generated.resources.*

val transactionIcon = Icons.Filled.Receipt

@Factory
class TransactionsScreen(
    @Named(DaoTransactionsRepository.KEY) repository: TransactionsRepository,
    @Named(DaoAccountsRepository.KEY) accountRepository: AccountsRepository,
    @Named(DaoCategoriesRepository.KEY) categoryRepository: CategoriesRepository,
    settingsRepository: SettingsRepository,
) : Tab {
    private val screenViewModel: TransactionsViewModel =
        TransactionsViewModel(repository, accountRepository, categoryRepository)
    private val settings: SettingsRepository = settingsRepository

    override val options: TabOptions
        @Composable
        get() {
            val title = stringResource(Res.string.transactions_list)
            val icon = rememberVectorPainter(transactionIcon)

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

        var transactionToEdit by remember { mutableStateOf<UserTransaction?>(null) }
        var showEditDialog by remember { mutableStateOf(false) }
        var transactionToDelete by remember { mutableStateOf<UserTransaction?>(null) }
        var showDateRangePicker by remember { mutableStateOf(false) }

        val itemActions = object : ItemActions<UserFullTransaction> {
            override fun onView(item: UserFullTransaction) {
                // TODO implement view
            }

            override fun onEdit(item: UserFullTransaction) {
                transactionToEdit = item.transaction
                showEditDialog = true
            }

            override fun onDelete(item: UserFullTransaction) {
                transactionToDelete = item.transaction
            }
        }

        var filterVisible by remember { mutableStateOf(false) }
        var sortField by remember { mutableStateOf(UserTransaction.COLUMN_DATETIME) }
        var sortOrder by remember { mutableStateOf(SortOrder.DESC) }
        var selectedAccount by remember { mutableStateOf<org.zp1ke.platasync.domain.UserAccount?>(null) }
        var selectedCategory by remember { mutableStateOf<org.zp1ke.platasync.domain.UserCategory?>(null) }
        var viewMode by remember { mutableStateOf(ViewMode.GRID) }
        var reloadTrigger by remember { mutableIntStateOf(0) }

        val coroutineScope = rememberCoroutineScope()

        // Load saved view mode on startup
        LaunchedEffect(Unit) {
            viewMode = settings.getViewMode(UserSetting.KEY_VIEW_MODE_TRANSACTIONS)
        }

        // Save view mode when it changes
        LaunchedEffect(viewMode) {
            coroutineScope.launch {
                settings.saveViewMode(UserSetting.KEY_VIEW_MODE_TRANSACTIONS, viewMode)
            }
        }

        // Trigger loadData whenever filter/sort parameters change or reload is requested
        LaunchedEffect(sortField, sortOrder, selectedAccount, selectedCategory, reloadTrigger) {
            viewModel.loadItems(
                sortKey = sortField,
                sortOrder = sortOrder,
                accountId = selectedAccount?.id,
                categoryId = selectedCategory?.id,
            )
        }

        val filterWidgetProvider = object : TopWidgetProvider {
            override fun action(): (@Composable () -> Unit) = {
                val isFiltered = sortField != UserTransaction.COLUMN_DATETIME ||
                        sortOrder != SortOrder.DESC ||
                        selectedAccount != null ||
                        selectedCategory != null
                val buttonColor = if (!filterVisible && isFiltered) {
                    MaterialTheme.colorScheme.tertiaryContainer
                } else {
                    MaterialTheme.colorScheme.surfaceVariant
                }
                val iconColor = if (!filterVisible && isFiltered) {
                    MaterialTheme.colorScheme.onTertiaryContainer
                } else {
                    MaterialTheme.colorScheme.onSurfaceVariant
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
                        TransactionsFilterWidget(
                            enabled = !state.isLoading,
                            sortField = sortField,
                            onSortFieldChange = { sortField = it },
                            sortOrder = sortOrder,
                            onSortOrderChange = { sortOrder = it },
                            selectedAccount = selectedAccount,
                            onAccountSelected = { selectedAccount = it },
                            selectedCategory = selectedCategory,
                            onCategorySelected = { selectedCategory = it },
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
                transactionToEdit = null
                showEditDialog = true
            },
            actions = itemActions,
            titleIcon = {
                Icon(
                    imageVector = transactionIcon,
                    contentDescription = stringResource(Res.string.transactions_list),
                    modifier = Modifier.width(Size.iconSmall),
                )
            },
            titleResource = Res.string.transactions_list,
            subtitle = {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(Spacing.small)
                ) {
                    val isDarkMode = isSystemInDarkTheme()
                    Icon(
                        imageVector = TransactionType.INCOME.icon(),
                        contentDescription = null,
                        tint = TransactionType.INCOME.color(isDarkMode),
                        modifier = Modifier.size(Size.iconSmall)
                    )
                    Text(
                        text = state.stats.income.formatAsMoney(),
                        style = MaterialTheme.typography.bodyMedium
                            .copy(
                                color = TransactionType.INCOME.color(isDarkMode),
                                fontWeight = FontWeight.W500
                            ),
                        modifier = Modifier.alignByBaseline(),
                        textAlign = TextAlign.End,
                    )
                    Icon(
                        imageVector = TransactionType.EXPENSE.icon(),
                        contentDescription = null,
                        tint = TransactionType.EXPENSE.color(isDarkMode),
                        modifier = Modifier.size(Size.iconSmall)
                    )
                    Text(
                        text = state.stats.expense.formatAsMoney(),
                        style = MaterialTheme.typography.bodyMedium
                            .copy(
                                color = TransactionType.EXPENSE.color(isDarkMode),
                                fontWeight = FontWeight.W500
                            ),
                        modifier = Modifier.alignByBaseline(),
                        textAlign = TextAlign.End,
                    )
                }
            },
            refreshResource = Res.string.transactions_refresh,
            addResource = Res.string.transaction_add,
            topActions = listOf(
                {
                    ViewModeToggle(
                        viewMode = viewMode,
                        onViewModeChange = { viewMode = it },
                        enabled = !state.isLoading
                    )
                },
                {
                    TextButton(
                        onClick = {
                            @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                            showDateRangePicker = true
                        },
                        enabled = !state.isLoading,
                    ) {
                        Text(state.dateRange.getLabel())
                    }
                }
            ),
            topWidgetProvider = filterWidgetProvider,
            list = { enabled, actions ->
                val isFiltered = sortField != UserTransaction.COLUMN_DATETIME ||
                        sortOrder != SortOrder.DESC ||
                        selectedAccount != null ||
                        selectedCategory != null
                BaseList(
                    items = state.data,
                    actions = actions,
                    enabled = enabled,
                    viewMode = viewMode,
                    emptyStringResource = if (isFiltered) Res.string.transactions_empty_with_filter else Res.string.transactions_empty,
                    itemContent = { transaction, mode, itemActions, isEnabled ->
                        TransactionItem(
                            transaction = transaction,
                            viewMode = mode,
                            actions = itemActions,
                            enabled = isEnabled
                        )
                    }
                )
            }
        )

        TransactionEditDialog(
            showDialog = showEditDialog,
            transaction = transactionToEdit,
            onDismiss = {
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                showEditDialog = false
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                transactionToEdit = null
            },
            onSubmit = { transaction ->
                viewModel.saveItem(transaction)
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                showEditDialog = false
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                transactionToEdit = null
                reloadTrigger++
            }
        )

        TransactionDeleteDialog(
            showDialog = transactionToDelete != null,
            transaction = transactionToDelete,
            onDismiss = {
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                transactionToDelete = null
            },
            onSubmit = {
                transactionToDelete?.let { viewModel.deleteItem(it) }
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                transactionToDelete = null
                reloadTrigger++
            }
        )

        DateRangePickerDialog(
            showDialog = showDateRangePicker,
            currentRange = state.dateRange,
            onDismiss = {
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                showDateRangePicker = false
            },
            onSubmit = { range ->
                viewModel.setRange(range)
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                showDateRangePicker = false
            }
        )
    }
}
