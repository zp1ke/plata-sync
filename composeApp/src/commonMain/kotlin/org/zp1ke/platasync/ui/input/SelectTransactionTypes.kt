package org.zp1ke.platasync.ui.input

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.TransactionTypeWidget
import org.zp1ke.platasync.ui.theme.Spacing

@OptIn(ExperimentalMaterial3Api::class)
@Composable
@Preview
fun SelectTransactionTypes(
    selectedTypes: List<TransactionType> = emptyList(),
    availableTypes: List<TransactionType> = listOf(TransactionType.INCOME, TransactionType.EXPENSE),
    onChanged: (List<TransactionType>) -> Unit = { _ -> },
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(Spacing.small)
    ) {
        availableTypes.forEach { type ->
            val isSelected = selectedTypes.contains(type)
            FilterChip(
                selected = isSelected,
                onClick = {
                    val newSelection = if (isSelected) {
                        selectedTypes - type
                    } else {
                        selectedTypes + type
                    }
                    onChanged(newSelection)
                },
                label = {
                    TransactionTypeWidget(type)
                }
            )
        }
    }
}
