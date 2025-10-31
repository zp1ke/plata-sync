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
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.data.repository.DaoAccountsRepository
import org.zp1ke.platasync.domain.BaseModel
import org.zp1ke.platasync.domain.UserAccount
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.formatMoney
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.transaction_target_account

@Composable
fun SelectTargetAccount(
    selectedTargetAccountId: String?,
    excludeAccountId: String?,
    onAccountSelected: (UserAccount) -> Unit,
    modifier: Modifier = Modifier,
    repository: BaseRepository<UserAccount> = koinInject(named(DaoAccountsRepository.KEY))
) {
    var accounts by remember { mutableStateOf<List<UserAccount>>(emptyList()) }
    var isLoading by remember { mutableStateOf(false) }
    var searchQuery by remember { mutableStateOf("") }
    var currentPage by remember { mutableIntStateOf(0) }
    var hasMore by remember { mutableStateOf(true) }
    val pageSize = 20
    val scope = rememberCoroutineScope()
    var searchJob by remember { mutableStateOf<Job?>(null) }

    val selectedAccount = remember(selectedTargetAccountId, accounts) {
        accounts.firstOrNull { it.id == selectedTargetAccountId }
    }

    fun loadAccounts(query: String, page: Int, append: Boolean = false) {
        scope.launch {
            isLoading = true
            try {
                val filters = if (query.isNotEmpty()) {
                    mapOf(UserAccount.COLUMN_NAME to query)
                } else {
                    emptyMap()
                }

                val allItems = repository.getAllItems(
                    filters = filters,
                    sortKey = BaseModel.COLUMN_CREATED_AT,
                    sortOrder = SortOrder.DESC
                )

                // Filter out the excluded account
                val filteredItems = if (excludeAccountId != null) {
                    allItems.filter { it.id != excludeAccountId }
                } else {
                    allItems
                }

                val startIndex = page * pageSize
                val endIndex = minOf(startIndex + pageSize, filteredItems.size)
                val pageItems = if (startIndex < filteredItems.size) {
                    filteredItems.subList(startIndex, endIndex)
                } else {
                    emptyList()
                }

                accounts = if (append) accounts + pageItems else pageItems
                hasMore = endIndex < filteredItems.size
            } finally {
                isLoading = false
            }
        }
    }

    // Reload when excludeAccountId changes
    LaunchedEffect(excludeAccountId) {
        currentPage = 0
        hasMore = true
        loadAccounts(searchQuery, 0)
    }

    ItemSelector(
        label = stringResource(Res.string.transaction_target_account),
        selectedItem = selectedAccount,
        items = accounts,
        onSearch = { query ->
            searchJob?.cancel()
            searchJob = scope.launch {
                delay(300) // Debounce
                searchQuery = query
                currentPage = 0
                hasMore = true
                loadAccounts(query, 0)
            }
        },
        onLoadMore = {
            if (hasMore && !isLoading) {
                currentPage++
                loadAccounts(searchQuery, currentPage, append = true)
            }
        },
        hasMore = hasMore,
        isLoading = isLoading,
        itemContent = { account ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(Spacing.small),
                verticalAlignment = Alignment.CenterVertically
            ) {
                ImageIcon(account.icon)
                Text(
                    text = account.name,
                    style = MaterialTheme.typography.bodyLarge,
                    modifier = Modifier.weight(1f)
                )
                Text(
                    text = formatMoney(account.balance),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.primary
                )
            }
        },
        itemKey = { it.id },
        itemText = { it.name },
        onItemSelected = onAccountSelected,
        modifier = modifier
    )
}

