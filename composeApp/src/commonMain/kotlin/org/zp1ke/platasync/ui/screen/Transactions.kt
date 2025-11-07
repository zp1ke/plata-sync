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
import org.jetbrains.compose.resources.stringResource
import org.koin.core.annotation.Factory
import org.koin.core.annotation.Named
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.model.UserFullTransaction
import org.zp1ke.platasync.data.repository.AccountsRepository
import org.zp1ke.platasync.data.repository.DaoAccountsRepository
import org.zp1ke.platasync.data.repository.DaoTransactionsRepository
import org.zp1ke.platasync.data.repository.TransactionsRepository
import org.zp1ke.platasync.data.viewModel.TransactionsViewModel
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.ui.common.BaseList
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.feature.transactions.DateRangePickerDialog
import org.zp1ke.platasync.ui.feature.transactions.TransactionDeleteDialog
import org.zp1ke.platasync.ui.feature.transactions.TransactionEditDialog
import org.zp1ke.platasync.ui.feature.transactions.TransactionsFilterWidget
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.util.formatAsDateTime
import org.zp1ke.platasync.util.formatAsMoney
import platasync.composeapp.generated.resources.*

val transactionIcon = Icons.Filled.Receipt

@Factory
class TransactionsScreen(
    @Named(DaoTransactionsRepository.KEY) repository: TransactionsRepository,
    @Named(DaoAccountsRepository.KEY) accountRepository: AccountsRepository,
) : Tab {
    private val screenViewModel: TransactionsViewModel = TransactionsViewModel(repository, accountRepository)

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
        var reloadTrigger by remember { mutableIntStateOf(0) }

        // Trigger loadData whenever filter/sort parameters change or reload is requested
        LaunchedEffect(sortField, sortOrder, reloadTrigger) {
            val filters = mutableMapOf<String, String>()
            viewModel.loadItems(
                filters = filters,
                sortKey = sortField,
                sortOrder = sortOrder,
            )
        }

        val filterWidgetProvider = object : TopWidgetProvider {
            override fun action(): (@Composable () -> Unit) = {
                val isFiltered = sortField != UserTransaction.COLUMN_DATETIME || sortOrder != SortOrder.DESC
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
            subtitle = state.stats.balance.formatAsMoney(),
            refreshResource = Res.string.transactions_refresh,
            addResource = Res.string.transaction_add,
            topActions = listOf(
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
                BaseList(
                    items = state.data,
                    actions = actions,
                    enabled = enabled,
                    emptyStringResource = if (true) Res.string.transactions_empty else Res.string.transactions_empty_with_filter,
                    editStringResource = Res.string.transaction_edit,
                    deleteStringResource = Res.string.transaction_delete,
                    headlineContent = { transaction ->
                        {
                            Row(modifier = Modifier.fillMaxWidth()) {
                                ImageIcon(
                                    transaction.account.icon,
                                    width = Size.iconSmall,
                                    modifier = Modifier.alignByBaseline(),
                                )
                                Text(
                                    text = transaction.account.name,
                                    style = MaterialTheme.typography.titleMedium
                                        .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                                    modifier = Modifier.alignByBaseline()
                                )
                                Text(
                                    text = " • ${transaction.transaction.datetime.formatAsDateTime()}",
                                    style = MaterialTheme.typography.bodySmall
                                        .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                                    modifier = Modifier.alignByBaseline()
                                )
                                Spacer(modifier = Modifier.weight(1f))
                                if (transaction.category != null) {
                                    ImageIcon(
                                        transaction.category.icon,
                                        width = Size.iconSmall,
                                        modifier = Modifier.alignByBaseline()
                                    )
                                    Text(
                                        text = transaction.category.name,
                                        style = MaterialTheme.typography.titleSmall
                                            .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                                        modifier = Modifier.alignByBaseline(),
                                    )
                                }
                            }
                        }
                    },
                    supportingContent = { trn ->
                        {
                            val isDarkMode = isSystemInDarkTheme()
                            Row(modifier = Modifier.fillMaxWidth()) {
                                Text(
                                    text = trn.signedAmount.formatAsMoney(),
                                    style = MaterialTheme.typography.bodyMedium
                                        .copy(
                                            color = trn.transactionType.color(isDarkMode),
                                            fontWeight = FontWeight.W500
                                        ),
                                    modifier = Modifier.alignByBaseline().fillMaxWidth(0.25f),
                                    textAlign = TextAlign.End,
                                )
                                Text(
                                    text = " = ",
                                    style = MaterialTheme.typography.bodyMedium,
                                    modifier = Modifier.alignByBaseline(),
                                )
                                Text(
                                    text = trn.transaction.accountBalanceAfter.formatAsMoney(),
                                    style = MaterialTheme.typography.bodyMedium
                                        .copy(fontWeight = FontWeight.W500),
                                    modifier = Modifier.alignByBaseline(),
                                )
                                Spacer(modifier = Modifier.weight(1f))
                                if (!trn.transaction.description.isNullOrBlank()) {
                                    Text(
                                        text = trn.transaction.description,
                                        style = MaterialTheme.typography.bodySmall
                                            .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                                        modifier = Modifier.weight(1f).alignByBaseline()
                                    )
                                }
                            }
                        }
                    },
                    leadingContent = { transaction ->
                        {
                            val isDarkMode = isSystemInDarkTheme()
                            Icon(
                                imageVector = transaction.transactionType.icon(),
                                contentDescription = null,
                                tint = transaction.transactionType.color(isDarkMode),
                                modifier = Modifier.size(Size.iconSmall)
                            )
                        }
                    },
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
