package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.filled.LocalOffer
import androidx.compose.material.icons.outlined.FilterListOff
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import org.jetbrains.compose.resources.stringResource
import org.koin.core.annotation.Factory
import org.koin.core.annotation.Named
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.repository.CategoriesRepository
import org.zp1ke.platasync.data.repository.DaoCategoriesRepository
import org.zp1ke.platasync.data.viewModel.CategoriesViewModel
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.domain.UserCategory
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.BaseList
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.common.TransactionTypeWidget
import org.zp1ke.platasync.ui.feature.categories.CategoriesFilterWidget
import org.zp1ke.platasync.ui.feature.categories.CategoryDeleteDialog
import org.zp1ke.platasync.ui.feature.categories.CategoryEditDialog
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.*

val categoryIcon = Icons.Filled.LocalOffer

@Factory
class CategoriesScreen(
    @Named(DaoCategoriesRepository.KEY) repository: CategoriesRepository,
) : Tab {
    private val screenViewModel: CategoriesViewModel = CategoriesViewModel(repository)

    override val options: TabOptions
        @Composable
        get() {
            val title = stringResource(Res.string.categories_list)
            val icon = rememberVectorPainter(categoryIcon)

            return remember {
                TabOptions(
                    index = 2u,
                    title = title,
                    icon = icon,
                )
            }
        }

    @Composable
    override fun Content() {
        val viewModel = remember { screenViewModel }
        val state by viewModel.state.collectAsState()

        var categoryToEdit by remember { mutableStateOf<UserCategory?>(null) }
        var showEditDialog by remember { mutableStateOf(false) }
        var categoryToDelete by remember { mutableStateOf<UserCategory?>(null) }

        val itemActions = object : ItemActions<UserCategory> {
            override fun onView(item: UserCategory) {
                // TODO implement view
            }

            override fun onEdit(item: UserCategory) {
                categoryToEdit = item
                showEditDialog = true
            }

            override fun onDelete(item: UserCategory) {
                categoryToDelete = item
            }
        }

        var filterVisible by remember { mutableStateOf(false) }
        var filterName by remember { mutableStateOf("") }
        var transactionType by remember { mutableStateOf<TransactionType?>(null) }
        var sortField by remember { mutableStateOf(UserCategory.COLUMN_LAST_USED_AT) }
        var sortOrder by remember { mutableStateOf(SortOrder.DESC) }
        var reloadTrigger by remember { mutableIntStateOf(0) }

        // Trigger loadData whenever filter/sort parameters change or reload is requested
        LaunchedEffect(filterName, transactionType, sortField, sortOrder, reloadTrigger) {
            val filters = mutableMapOf<String, String>()
            val trimmedFilterName = filterName.trim()
            if (trimmedFilterName.isNotBlank()) {
                filters[UserCategory.COLUMN_NAME] = trimmedFilterName
            }
            transactionType?.let {
                filters[UserCategory.COLUMN_TRANSACTION_TYPES] = it.name
            }
            viewModel.loadItems(
                filters = filters,
                sortKey = sortField,
                sortOrder = sortOrder,
            )
        }

        val filterWidgetProvider = object : TopWidgetProvider {
            override fun action(): (@Composable () -> Unit) = {
                val isFiltered =
                    filterName.isNotBlank() || transactionType != null || sortField != DomainModel.COLUMN_CREATED_AT || sortOrder != SortOrder.DESC
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
                        CategoriesFilterWidget(
                            enabled = !state.isLoading,
                            filterName = filterName,
                            onFilterNameChange = { filterName = it },
                            sortField = sortField,
                            onSortFieldChange = { sortField = it },
                            sortOrder = sortOrder,
                            onSortOrderChange = { sortOrder = it },
                            transactionType = transactionType,
                            onTransactionTypeChange = { transactionType = it },
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
                categoryToEdit = null
                showEditDialog = true
            },
            actions = itemActions,
            titleIcon = {
                Icon(
                    imageVector = categoryIcon,
                    contentDescription = stringResource(Res.string.categories_list),
                    modifier = Modifier.width(Size.iconSmall),
                )
            },
            titleResource = Res.string.categories_list,
            refreshResource = Res.string.categories_refresh,
            addResource = Res.string.category_add,
            topWidgetProvider = filterWidgetProvider,
            list = { enabled, actions ->
                BaseList(
                    items = state.data,
                    actions = actions,
                    enabled = enabled,
                    emptyStringResource = if (filterName.isBlank() && transactionType == null) Res.string.categories_empty else Res.string.categories_empty_with_filter,
                    editStringResource = Res.string.category_edit,
                    deleteStringResource = Res.string.category_delete,
                    itemHeadlineContent = { category ->
                        {
                            Text(
                                text = category.name,
                                style = MaterialTheme.typography.titleMedium
                                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                            )
                        }
                    },
                    itemSupportingContent = { category ->
                        {
                            Row(
                                horizontalArrangement = Arrangement.spacedBy(Spacing.small)
                            ) {
                                category.transactionTypes.forEach { TransactionTypeWidget(it) }
                            }
                        }
                    },
                    itemLeadingContent = { category ->
                        {
                            ImageIcon(category.icon)
                        }
                    },
                )
            }
        )

        CategoryEditDialog(
            showDialog = showEditDialog,
            category = categoryToEdit,
            onDismiss = {
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                showEditDialog = false
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                categoryToEdit = null
            },
            onSubmit = { category ->
                viewModel.saveItem(category)
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                showEditDialog = false
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                categoryToEdit = null
                reloadTrigger++
            }
        )

        CategoryDeleteDialog(
            showDialog = categoryToDelete != null,
            category = categoryToDelete,
            onDismiss = {
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                categoryToDelete = null
            },
            onSubmit = {
                categoryToDelete?.let { viewModel.deleteItem(it) }
                @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
                categoryToDelete = null
                reloadTrigger++
            }
        )
    }
}
