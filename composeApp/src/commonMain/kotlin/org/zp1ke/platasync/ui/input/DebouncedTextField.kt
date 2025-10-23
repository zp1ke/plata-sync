package org.zp1ke.platasync.ui.input

import androidx.compose.material3.OutlinedTextField
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import kotlinx.coroutines.delay

@Composable
fun DebouncedTextField(
    value: String,
    onValueChange: (String) -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    label: @Composable (() -> Unit)? = null,
    placeholder: @Composable (() -> Unit)? = null,
    leadingIcon: @Composable (() -> Unit)? = null,
    trailingIcon: @Composable (() -> Unit)? = null,
    singleLine: Boolean = true,
    maxLines: Int = if (singleLine) 1 else Int.MAX_VALUE,
    minLines: Int = 1,
    debounceMillis: Long = 500,
) {
    // Local state for immediate UI updates
    var localValue by remember(value) { mutableStateOf(value) }

    // Debounce the value change
    LaunchedEffect(localValue) {
        delay(debounceMillis)
        if (localValue != value) {
            onValueChange(localValue)
        }
    }

    OutlinedTextField(
        value = localValue,
        onValueChange = { localValue = it },
        modifier = modifier,
        enabled = enabled,
        label = label,
        placeholder = placeholder,
        leadingIcon = leadingIcon,
        trailingIcon = trailingIcon,
        singleLine = singleLine,
        maxLines = maxLines,
        minLines = minLines,
    )
}

