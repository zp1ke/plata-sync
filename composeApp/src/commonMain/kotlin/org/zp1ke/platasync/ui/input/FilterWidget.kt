package org.zp1ke.platasync.ui.input

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.data.dao.SortOrder
import org.zp1ke.platasync.model.BaseModel
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BaseFilterWidget(
    sortField: String,
    sortFieldOptions: Map<String, StringResource> = mapOf(
        BaseModel.COLUMN_CREATED_AT to Res.string.sort_field_created,
    ),
    onSortFieldChange: (String) -> Unit,
    sortOrder: SortOrder,
    onSortOrderChange: (SortOrder) -> Unit,
    extras: List<(@Composable () -> Unit)> = listOf(),
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

        @Composable
        fun sortFieldTitle(field: String): String {
            val resId = sortFieldOptions[field] ?: return field
            return stringResource(resId)
        }

        ExposedDropdownMenuBox(
            expanded = sortFieldExpanded,
            onExpandedChange = { sortFieldExpanded = it },
        ) {
            OutlinedTextField(
                value = sortFieldTitle(sortField),
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
                sortFieldOptions.entries.forEach { entry ->
                    DropdownMenuItem(
                        text = { Text(stringResource(entry.value)) },
                        onClick = {
                            onSortFieldChange(entry.key)
                            sortFieldExpanded = false
                        },
                        contentPadding = ExposedDropdownMenuDefaults.ItemContentPadding,
                    )
                }
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

        // Extras
        extras.forEach { extra ->
            extra()
        }
    }
}

@Composable
private fun getSortOrderLabel(sortOrder: SortOrder): String {
    return when (sortOrder) {
        SortOrder.ASC -> stringResource(Res.string.sort_order_asc)
        SortOrder.DESC -> stringResource(Res.string.sort_order_desc)
    }
}

