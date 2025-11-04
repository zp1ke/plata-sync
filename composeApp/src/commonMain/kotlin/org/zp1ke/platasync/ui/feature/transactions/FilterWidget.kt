package org.zp1ke.platasync.ui.feature.transactions

import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.Composable
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.ui.input.BaseFilterWidget
import platasync.composeapp.generated.resources.Res
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
        extras = listOf(),
    )
}


