package org.zp1ke.platasync.ui.input

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.koinInject
import org.koin.core.qualifier.named
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.repository.CategoriesRepository
import org.zp1ke.platasync.data.repository.DaoCategoriesRepository
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.domain.UserCategory
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.common.TransactionTypeWidget
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.transaction_category

@Composable
fun SelectCategory(
    selectedCategoryId: String?,
    transactionType: TransactionType?,
    onCategorySelected: (UserCategory) -> Unit,
    modifier: Modifier = Modifier,
    repository: CategoriesRepository = koinInject(named(DaoCategoriesRepository.KEY))
) {
    var categories by remember { mutableStateOf<List<UserCategory>>(emptyList()) }
    var isLoading by remember { mutableStateOf(false) }
    var searchQuery by remember { mutableStateOf("") }
    var currentPage by remember { mutableIntStateOf(0) }
    var hasMore by remember { mutableStateOf(true) }
    val pageSize = 20
    val scope = rememberCoroutineScope()
    var searchJob by remember { mutableStateOf<Job?>(null) }

    val selectedCategory = remember(selectedCategoryId, categories) {
        categories.firstOrNull { it.id == selectedCategoryId }
    }

    fun loadCategories(query: String, page: Int, append: Boolean = false) {
        scope.launch {
            isLoading = true
            try {
                val filters = mutableMapOf<String, String>()
                if (query.isNotEmpty()) {
                    filters[UserCategory.COLUMN_NAME] = query
                }
                // Filter by transaction type only if provided
                if (transactionType != null) {
                    filters[UserCategory.COLUMN_TRANSACTION_TYPES] = transactionType.name
                }

                val allItems = repository.getAllItems(
                    filters = filters,
                    sortKey = DomainModel.COLUMN_CREATED_AT,
                    sortOrder = SortOrder.DESC
                )

                val startIndex = page * pageSize
                val endIndex = minOf(startIndex + pageSize, allItems.size)
                val pageItems = if (startIndex < allItems.size) {
                    allItems.subList(startIndex, endIndex)
                } else {
                    emptyList()
                }

                categories = if (append) categories + pageItems else pageItems
                hasMore = endIndex < allItems.size
            } finally {
                isLoading = false
            }
        }
    }

    // Load categories when transaction type changes
    LaunchedEffect(transactionType) {
        currentPage = 0
        hasMore = true
        loadCategories("", 0)
    }

    ItemSelector(
        label = stringResource(Res.string.transaction_category),
        selectedItem = selectedCategory,
        items = categories,
        onSearch = { query ->
            searchJob?.cancel()
            @Suppress("ASSIGNED_VALUE_IS_NEVER_READ")
            searchJob = scope.launch {
                delay(300) // Debounce
                searchQuery = query
                currentPage = 0
                hasMore = true
                loadCategories(query, 0)
            }
        },
        onLoadMore = {
            if (hasMore && !isLoading) {
                currentPage++
                loadCategories(searchQuery, currentPage, append = true)
            }
        },
        hasMore = hasMore,
        isLoading = isLoading,
        itemContent = { category ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(Spacing.small),
                verticalAlignment = Alignment.CenterVertically
            ) {
                ImageIcon(category.icon)
                Text(
                    text = category.name,
                    style = MaterialTheme.typography.bodyLarge,
                    modifier = Modifier.weight(1f)
                )
                // Show applicable transaction types
                Row(
                    horizontalArrangement = Arrangement.spacedBy(Spacing.small),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    category.transactionTypes.forEach { type ->
                        TransactionTypeWidget(type = type)
                    }
                }
            }
        },
        itemKey = { it.id },
        itemText = { it.name },
        onItemSelected = onCategorySelected,
        modifier = modifier
    )
}
