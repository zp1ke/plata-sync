package org.zp1ke.platasync.ui.input

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.form_invalid_amount

@Composable
@Preview
fun MoneyField(
    modifier: Modifier = Modifier,
    value: Int = 12345, // value in cents
    onValueChange: (Int) -> Unit = {},
    label: String = "",
    enabled: Boolean = true,
) {
    // Split value into integer and decimal parts (value is in cents)
    val integerPart = value / 100
    val decimalPart = value % 100

    var integerText by remember(integerPart) { mutableStateOf(if (integerPart == 0) "" else integerPart.toString()) }
    var decimalText by remember(decimalPart) { mutableStateOf(decimalPart.toString().padStart(2, '0')) }
    var isError by remember { mutableStateOf(false) }

    Column(modifier = modifier) {
        Text(
            text = label,
            style = MaterialTheme.typography.bodySmall,
            color = if (isError)
                MaterialTheme.colorScheme.error
            else
                MaterialTheme.colorScheme.onSurfaceVariant
        )

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.End,
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Integer part input
            OutlinedTextField(
                value = integerText,
                onValueChange = { newValue ->
                    val parsedInt = if (newValue.isEmpty()) 0 else newValue.toIntOrNull()

                    if (newValue.isEmpty() || (parsedInt != null && parsedInt >= 0)) {
                        integerText = newValue
                        val totalValue = (parsedInt ?: 0) * 100 + (decimalText.toIntOrNull() ?: 0)
                        onValueChange(totalValue)
                        isError = false
                    } else {
                        isError = true
                    }
                },
                modifier = Modifier.weight(1f),
                enabled = enabled,
                isError = isError,
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Number
                ),
                singleLine = true,
                textStyle = TextStyle(textAlign = TextAlign.End)
            )

            // Decimal separator
            Text(
                text = ".",
                style = MaterialTheme.typography.titleLarge,
                modifier = Modifier.padding(horizontal = Spacing.small),
                color = if (isError)
                    MaterialTheme.colorScheme.error
                else
                    MaterialTheme.colorScheme.onSurface
            )

            // Decimal part input (max 2 digits)
            OutlinedTextField(
                value = decimalText,
                onValueChange = { newValue ->
                    if (newValue.length <= 2) {
                        val parsedDecimal = newValue.toIntOrNull()

                        if (parsedDecimal != null && parsedDecimal >= 0 && parsedDecimal < 100) {
                            decimalText = newValue
                            val intPart = if (integerText.isEmpty()) 0 else integerText.toIntOrNull() ?: 0
                            val totalValue = intPart * 100 + parsedDecimal
                            onValueChange(totalValue)
                            isError = false
                        } else if (newValue.isEmpty()) {
                            decimalText = "00"
                            val intPart = if (integerText.isEmpty()) 0 else integerText.toIntOrNull() ?: 0
                            val totalValue = intPart * 100
                            onValueChange(totalValue)
                            isError = false
                        } else {
                            isError = true
                        }
                    }
                },
                modifier = Modifier.width(60.dp),
                enabled = enabled,
                isError = isError,
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Number
                ),
                singleLine = true,
                textStyle = TextStyle(textAlign = TextAlign.Start)
            )
        }

        if (isError) {
            Text(
                text = stringResource(Res.string.form_invalid_amount),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.error,
                modifier = Modifier.padding(start = Spacing.medium, top = Spacing.small)
            )
        }
    }
}
