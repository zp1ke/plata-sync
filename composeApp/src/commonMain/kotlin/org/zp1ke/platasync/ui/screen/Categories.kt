package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Category
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.outlined.FilterListOff
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import org.jetbrains.compose.resources.stringResource
import org.koin.core.annotation.Factory
import org.koin.core.annotation.Named
import org.zp1ke.platasync.data.dao.SortOrder
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.data.repository.DaoCategoriesRepository
import org.zp1ke.platasync.data.viewModel.BaseViewModel
import org.zp1ke.platasync.model.BaseModel
import org.zp1ke.platasync.model.UserCategory
import org.zp1ke.platasync.ui.common.BaseList
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.screen.categories.CategoriesFilterWidget
import org.zp1ke.platasync.ui.screen.categories.CategoryDeleteDialog
import org.zp1ke.platasync.ui.screen.categories.CategoryEditDialog
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.*

@Factory
class CategoriesScreen(
    @Named(DaoCategoriesRepository.KEY) repository: BaseRepository<UserCategory>,
) : Tab {
    private val screenViewModel: BaseViewModel<UserCategory> = BaseViewModel(repository)

    override val options: TabOptions
        @Composable
        get() {
            val title = stringResource(Res.string.categories_list)
            val icon = rememberVectorPainter(Icons.Filled.Category)

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
        var sortField by remember { mutableStateOf(BaseModel.COLUMN_CREATED_AT) }
        var sortOrder by remember { mutableStateOf(SortOrder.DESC) }
        var reloadTrigger by remember { mutableIntStateOf(0) }

        // Trigger loadData whenever filter/sort parameters change or reload is requested
        LaunchedEffect(filterName, sortField, sortOrder, reloadTrigger) {
            val filters = mutableMapOf<String, String>()
            val trimmedFilterName = filterName.trim()
            if (trimmedFilterName.isNotBlank()) {
                filters[UserCategory.COLUMN_NAME] = trimmedFilterName
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
                    filterName.isNotBlank() || sortField != BaseModel.COLUMN_CREATED_AT || sortOrder != SortOrder.DESC
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
                    imageVector = Icons.Filled.Category,
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
                    emptyStringResource = if (filterName.isBlank()) Res.string.categories_empty else Res.string.categories_empty_with_filter,
                    editStringResource = Res.string.category_edit,
                    deleteStringResource = Res.string.category_delete,
                    headlineContent = { category ->
                        {
                            Text(
                                text = category.name,
                                style = MaterialTheme.typography.titleMedium
                                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                            )
                        }
                    },
                    supportingContent = { category ->
                        {
                            Row(
                                horizontalArrangement = Arrangement.spacedBy(Spacing.small)
                            ) {
                                category.transactionTypes.forEach { type ->
                                    Row(
                                        horizontalArrangement = Arrangement.spacedBy(Spacing.small),
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Icon(
                                            imageVector = type.icon(),
                                            contentDescription = null,
                                            tint = type.color(),
                                            modifier = Modifier.size(Size.iconSmall)
                                        )
                                        Text(
                                            text = stringResource(type.title()),
                                            style = MaterialTheme.typography.bodyMedium,
                                            color = type.color()
                                        )
                                    }
                                }
                            }
                        }
                    },
                    leadingContent = { category ->
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
                viewModel.addItem(category)
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
