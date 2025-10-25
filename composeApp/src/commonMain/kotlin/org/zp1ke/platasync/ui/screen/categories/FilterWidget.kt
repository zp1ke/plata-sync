package org.zp1ke.platasync.ui.screen.categories

import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.key
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.data.dao.SortOrder
import org.zp1ke.platasync.model.BaseModel
import org.zp1ke.platasync.model.UserCategory
import org.zp1ke.platasync.ui.input.BaseFilterWidget
import org.zp1ke.platasync.ui.input.DebouncedTextField
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
            }
        ),
    )
}


