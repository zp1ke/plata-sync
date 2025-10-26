package org.zp1ke.platasync.ui.feature.categories

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.key
import androidx.compose.ui.Modifier
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.domain.BaseModel
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.domain.UserCategory
import org.zp1ke.platasync.ui.common.TransactionTypeWidget
import org.zp1ke.platasync.ui.input.BaseFilterWidget
import org.zp1ke.platasync.ui.input.DebouncedTextField
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.categories_sort_field_name
import platasync.composeapp.generated.resources.sort_field_created

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CategoriesFilterWidget(
    enabled: Boolean,
    filterName: String,
    onFilterNameChange: (String) -> Unit,
    sortField: String,
    onSortFieldChange: (String) -> Unit,
    sortOrder: SortOrder,
    onSortOrderChange: (SortOrder) -> Unit,
    transactionType: TransactionType?,
    onTransactionTypeChange: (TransactionType?) -> Unit,
) {
    BaseFilterWidget(
        enabled = enabled,
        sortField = sortField,
        sortFieldOptions = mapOf(
            BaseModel.COLUMN_CREATED_AT to Res.string.sort_field_created,
            UserCategory.COLUMN_NAME to Res.string.categories_sort_field_name,
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
                        label = { Text(stringResource(Res.string.categories_sort_field_name)) },
                        singleLine = true,
                    )
                }

                // Filter by transaction type (single select: Income/Expense only, no Transfer)
                key("transaction_type_field") {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(Spacing.small)
                    ) {
                        val availableTypes = listOf(TransactionType.INCOME, TransactionType.EXPENSE)
                        availableTypes.forEach { type ->
                            val isSelected = transactionType == type
                            FilterChip(
                                selected = isSelected,
                                enabled = enabled,
                                onClick = {
                                    // Toggle: if already selected, deselect it; otherwise select it
                                    onTransactionTypeChange(if (isSelected) null else type)
                                },
                                label = {
                                    TransactionTypeWidget(type)
                                }
                            )
                        }
                    }
                }
            }
        ),
    )
}


