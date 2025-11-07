package org.zp1ke.platasync.ui.feature.transactions

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.koinInject
import org.koin.core.qualifier.named
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.repository.AccountsRepository
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.data.repository.DaoAccountsRepository
import org.zp1ke.platasync.data.repository.DaoCategoriesRepository
import org.zp1ke.platasync.domain.UserAccount
import org.zp1ke.platasync.domain.UserCategory
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.ui.input.BaseFilterWidget
import org.zp1ke.platasync.ui.input.SelectAccount
import org.zp1ke.platasync.ui.input.SelectCategory
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.action_clear
import platasync.composeapp.generated.resources.transactions_sort_field_amount
import platasync.composeapp.generated.resources.transactions_sort_field_datetime

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TransactionsFilterWidget(
    enabled: Boolean,
    sortField: String,
    onSortFieldChange: (String) -> Unit,
    sortOrder: SortOrder,
    onSortOrderChange: (SortOrder) -> Unit,
    selectedAccount: UserAccount? = null,
    onAccountSelected: (UserAccount?) -> Unit = {},
    selectedCategory: UserCategory? = null,
    onCategorySelected: (UserCategory?) -> Unit = {},
    accountRepository: AccountsRepository = koinInject(named(DaoAccountsRepository.KEY)),
    categoryRepository: BaseRepository<UserCategory> = koinInject(named(DaoCategoriesRepository.KEY))
) {
    BaseFilterWidget(
        enabled = enabled,
        sortField = sortField,
        sortFieldOptions = mapOf(
            UserTransaction.COLUMN_DATETIME to Res.string.transactions_sort_field_datetime,
            UserTransaction.COLUMN_AMOUNT to Res.string.transactions_sort_field_amount,
        ),
        onSortFieldChange = onSortFieldChange,
        sortOrder = sortOrder,
        onSortOrderChange = onSortOrderChange,
        extras = listOf(
            {
                Row(
                    horizontalArrangement = Arrangement.spacedBy(Spacing.small),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    SelectAccount(
                        selectedAccountId = selectedAccount?.id,
                        onAccountSelected = { account -> onAccountSelected(account) },
                        modifier = Modifier.weight(1f),
                        repository = accountRepository
                    )
                    if (selectedAccount != null) {
                        IconButton(
                            onClick = { onAccountSelected(null) },
                            modifier = Modifier.size(Spacing.medium)
                        ) {
                            Icon(
                                imageVector = Icons.Default.Clear,
                                contentDescription = stringResource(Res.string.action_clear)
                            )
                        }
                    }
                }
            },
            {
                Row(
                    horizontalArrangement = Arrangement.spacedBy(Spacing.small),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    SelectCategory(
                        selectedCategoryId = selectedCategory?.id,
                        transactionType = null, // Show all categories
                        onCategorySelected = { category -> onCategorySelected(category) },
                        modifier = Modifier.weight(1f),
                        repository = categoryRepository
                    )
                    if (selectedCategory != null) {
                        IconButton(
                            onClick = { onCategorySelected(null) },
                            modifier = Modifier.size(Spacing.medium)
                        ) {
                            Icon(
                                imageVector = Icons.Default.Clear,
                                contentDescription = stringResource(Res.string.action_clear)
                            )
                        }
                    }
                }
            }
        ),
    )
}


