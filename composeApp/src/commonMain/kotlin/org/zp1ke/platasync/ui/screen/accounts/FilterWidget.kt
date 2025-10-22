package org.zp1ke.platasync.ui.screen.accounts

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.data.dao.SortOrder
import org.zp1ke.platasync.model.BaseModel
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AccountsFilterWidget(
    filterName: String,
    onFilterNameChange: (String) -> Unit,
    sortField: String,
    onSortFieldChange: (String) -> Unit,
    sortOrder: SortOrder,
    onSortOrderChange: (SortOrder) -> Unit,
) {
    FlowRow(
        modifier = Modifier
            .fillMaxWidth()
            .padding(Spacing.small),
        horizontalArrangement = Arrangement.spacedBy(Spacing.medium),
        verticalArrangement = Arrangement.spacedBy(Spacing.small),
    ) {
        // Sort field selector
        var sortFieldExpanded by remember { mutableStateOf(false) }
        ExposedDropdownMenuBox(
            expanded = sortFieldExpanded,
            onExpandedChange = { sortFieldExpanded = it },
        ) {
            OutlinedTextField(
                value = getSortFieldLabel(sortField),
                onValueChange = {},
                readOnly = true,
                label = { Text(stringResource(Res.string.sort_by)) },
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = sortFieldExpanded) },
                modifier = Modifier
                    .menuAnchor(ExposedDropdownMenuAnchorType.PrimaryNotEditable),
                colors = ExposedDropdownMenuDefaults.outlinedTextFieldColors(),
            )
            ExposedDropdownMenu(
                expanded = sortFieldExpanded,
                onDismissRequest = { sortFieldExpanded = false },
            ) {
                DropdownMenuItem(
                    text = { Text(stringResource(Res.string.sort_field_created)) },
                    onClick = {
                        onSortFieldChange(BaseModel.COLUMN_CREATED_AT)
                        sortFieldExpanded = false
                    },
                    contentPadding = ExposedDropdownMenuDefaults.ItemContentPadding,
                )
                DropdownMenuItem(
                    text = { Text(stringResource(Res.string.accounts_sort_field_name)) },
                    onClick = {
                        onSortFieldChange(UserAccount.COLUMN_NAME)
                        sortFieldExpanded = false
                    },
                    contentPadding = ExposedDropdownMenuDefaults.ItemContentPadding,
                )
                DropdownMenuItem(
                    text = { Text(stringResource(Res.string.accounts_sort_field_balance)) },
                    onClick = {
                        onSortFieldChange(UserAccount.COLUMN_INITIAL_BALANCE)
                        sortFieldExpanded = false
                    },
                    contentPadding = ExposedDropdownMenuDefaults.ItemContentPadding,
                )
            }
        }

        // Sort order selector
        OutlinedButton(
            onClick = {
                onSortOrderChange(if (sortOrder == SortOrder.ASC) SortOrder.DESC else SortOrder.ASC)
            },
            modifier = Modifier.padding(Spacing.small),
        ) {
            Icon(
                imageVector = if (sortOrder == SortOrder.ASC) Icons.Filled.ArrowUpward else Icons.Filled.ArrowDownward,
                contentDescription = null,
            )
            Spacer(modifier = Modifier.width(Spacing.small))
            Text(text = getSortOrderLabel(sortOrder))
        }

        // Filter by name
        OutlinedTextField(
            value = filterName,
            onValueChange = onFilterNameChange,
            label = { Text(stringResource(Res.string.accounts_sort_field_name)) },
            singleLine = true,
        )
    }
}

@Composable
private fun getSortFieldLabel(sortField: String): String {
    return when (sortField) {
        BaseModel.COLUMN_CREATED_AT -> stringResource(Res.string.sort_field_created)
        UserAccount.COLUMN_NAME -> stringResource(Res.string.accounts_sort_field_name)
        UserAccount.COLUMN_INITIAL_BALANCE -> stringResource(Res.string.accounts_sort_field_balance)
        else -> sortField
    }
}

@Composable
private fun getSortOrderLabel(sortOrder: SortOrder): String {
    return when (sortOrder) {
        SortOrder.ASC -> stringResource(Res.string.sort_order_asc)
        SortOrder.DESC -> stringResource(Res.string.sort_order_desc)
    }
}

