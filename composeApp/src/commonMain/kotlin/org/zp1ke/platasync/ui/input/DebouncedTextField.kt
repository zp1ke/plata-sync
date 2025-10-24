package org.zp1ke.platasync.ui.input

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import kotlinx.coroutines.delay
import org.jetbrains.compose.resources.stringResource
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.action_clear

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
    showClearButton: Boolean = true,
) {
    // Local state for immediate UI updates
    var localValue by remember { mutableStateOf(value) }

    // Sync external value changes only when local hasn't been modified
    LaunchedEffect(value) {
        if (localValue != value) {
            localValue = value
        }
    }

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
        trailingIcon = {
            if (showClearButton && localValue.isNotEmpty()) {
                IconButton(onClick = {
                    localValue = ""
                    onValueChange("")
                }) {
                    Icon(
                        imageVector = Icons.Default.Clear,
                        contentDescription = stringResource(Res.string.action_clear),
                    )
                }
            } else {
                trailingIcon?.invoke()
            }
        },
        singleLine = singleLine,
        maxLines = maxLines,
        minLines = minLines,
    )
}

