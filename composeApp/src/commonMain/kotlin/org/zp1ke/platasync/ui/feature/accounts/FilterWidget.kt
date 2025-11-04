package org.zp1ke.platasync.ui.feature.accounts

import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.key
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.domain.UserAccount
import org.zp1ke.platasync.ui.input.BaseFilterWidget
import org.zp1ke.platasync.ui.input.DebouncedTextField
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.accounts_sort_field_balance
import platasync.composeapp.generated.resources.accounts_sort_field_last_used_at
import platasync.composeapp.generated.resources.accounts_sort_field_name

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AccountsFilterWidget(
    enabled: Boolean,
    filterName: String,
    onFilterNameChange: (String) -> Unit,
    sortField: String,
    onSortFieldChange: (String) -> Unit,
    sortOrder: SortOrder,
    onSortOrderChange: (SortOrder) -> Unit,
) {
    BaseFilterWidget(
        enabled = enabled,
        sortField = sortField,
        sortFieldOptions = mapOf(
            UserAccount.COLUMN_LAST_USED_AT to Res.string.accounts_sort_field_last_used_at,
            UserAccount.COLUMN_NAME to Res.string.accounts_sort_field_name,
            UserAccount.COLUMN_BALANCE to Res.string.accounts_sort_field_balance,
        ),
        onSortFieldChange = onSortFieldChange,
        sortOrder = sortOrder,
        onSortOrderChange = onSortOrderChange,
        extras = listOf(
            {
                // Filter by name - use key to maintain identity across recompositions
                key("filter_name_field") {
                    DebouncedTextField(
                        value = filterName,
                        onValueChange = onFilterNameChange,
                        enabled = enabled,
                        label = { Text(stringResource(Res.string.accounts_sort_field_name)) },
                        singleLine = true,
                    )
                }
            }
        ),
    )
}


