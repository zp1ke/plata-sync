package org.zp1ke.platasync.ui.common

import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.util.formatAsMoney
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.form_invalid_amount

@Composable
fun MoneyField(
    value: Int,
    onValueChange: (Int) -> Unit,
    label: String,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
) {
    var textValue by remember(value) { mutableStateOf(if (value == 0) "" else value.toString()) }
    var isError by remember { mutableStateOf(false) }

    OutlinedTextField(
        value = textValue,
        onValueChange = { newValue ->
            val isEmpty = newValue.isEmpty()
            val parsedValue = if (isEmpty) 0 else newValue.toIntOrNull()

            if (!isEmpty && parsedValue != null && parsedValue >= 0) {
                onValueChange(parsedValue)
            } else if (isEmpty) {
                onValueChange(0)
            }
        },
        label = { Text(label) },
        modifier = modifier,
        enabled = enabled,
        isError = isError,
        keyboardOptions = KeyboardOptions(
            keyboardType = KeyboardType.Number
        ),
        singleLine = true,
        supportingText = if (isError) {
            { Text(stringResource(Res.string.form_invalid_amount)) }
        } else null
    )
}
