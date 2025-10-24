package org.zp1ke.platasync.ui.screen.accounts

import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.data.dao.SortOrder
import org.zp1ke.platasync.model.BaseModel
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.input.BaseFilterWidget
import org.zp1ke.platasync.ui.input.DebouncedTextField
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.accounts_sort_field_balance
import platasync.composeapp.generated.resources.accounts_sort_field_name
import platasync.composeapp.generated.resources.sort_field_created

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
            BaseModel.COLUMN_CREATED_AT to Res.string.sort_field_created,
            UserAccount.COLUMN_NAME to Res.string.accounts_sort_field_name,
            UserAccount.COLUMN_BALANCE to Res.string.accounts_sort_field_balance,
        ),
        onSortFieldChange = onSortFieldChange,
        sortOrder = sortOrder,
        onSortOrderChange = onSortOrderChange,
        extras = listOf(
            {
                // Filter by name
                DebouncedTextField(
                    value = filterName,
                    onValueChange = onFilterNameChange,
                    enabled = enabled,
                    label = { Text(stringResource(Res.string.accounts_sort_field_name)) },
                    singleLine = true,
                )
            }
        ),
    )
}
