package org.zp1ke.platasync.ui.feature.transactions

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.model.DateRangePreset
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.formatAsDate
import platasync.composeapp.generated.resources.*
import java.time.OffsetDateTime

@Composable
fun DateRangePickerDialog(
    showDialog: Boolean = false,
    currentRange: DateRangePreset,
    onDismiss: () -> Unit = {},
    onSubmit: (range: DateRangePreset) -> Unit = { _ -> },
) {
    if (!showDialog) return

    val now = remember { OffsetDateTime.now() }

    var selectedPreset by remember(showDialog) {
        mutableStateOf(currentRange)
    }

    var fromDate by remember(showDialog) { mutableStateOf(currentRange.getDateRange().first) }
    var toDate by remember(showDialog) { mutableStateOf(currentRange.getDateRange().second) }

    // Update dates when preset changes
    LaunchedEffect(selectedPreset) {
        val (from, to) = selectedPreset.getDateRange(now)
        fromDate = from
        toDate = to
    }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false)
    ) {
        Card(
            modifier = Modifier
                .fillMaxWidth(0.9f)
                .padding(Spacing.medium),
            elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
        ) {
            Column(
                modifier = Modifier
                    .padding(16.dp)
                    .verticalScroll(rememberScrollState()),
                verticalArrangement = Arrangement.spacedBy(Spacing.medium)
            ) {
                // Title
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(Spacing.small)
                ) {
                    Icon(
                        imageVector = Icons.Filled.DateRange,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.primary
                    )
                    Text(
                        text = stringResource(Res.string.date_range_picker_title),
                        style = MaterialTheme.typography.headlineSmall,
                        color = MaterialTheme.colorScheme.onSurface
                    )
                }

                HorizontalDivider()

                // Preset Options
                Text(
                    text = stringResource(Res.string.date_range_presets),
                    style = MaterialTheme.typography.titleMedium,
                    color = MaterialTheme.colorScheme.onSurface
                )

                Column(verticalArrangement = Arrangement.spacedBy(Spacing.small)) {
                    DateRangePreset.entries.forEach { preset ->
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            RadioButton(
                                selected = selectedPreset == preset,
                                onClick = { selectedPreset = preset }
                            )
                            Text(
                                text = preset.getLabel(),
                                style = MaterialTheme.typography.bodyLarge,
                                modifier = Modifier.weight(1f)
                            )
                        }
                    }
                }

                HorizontalDivider()

                // Date Range Display
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.secondaryContainer
                    )
                ) {
                    Column(
                        modifier = Modifier.padding(Spacing.medium),
                        verticalArrangement = Arrangement.spacedBy(Spacing.small)
                    ) {
                        Text(
                            text = stringResource(Res.string.date_range_selected),
                            style = MaterialTheme.typography.labelLarge,
                            color = MaterialTheme.colorScheme.onSecondaryContainer
                        )
                        Text(
                            text = "${fromDate.formatAsDate()} - ${toDate.formatAsDate()}",
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.onSecondaryContainer
                        )
                    }
                }

                // Action Buttons
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(Spacing.small, Alignment.End)
                ) {
                    TextButton(onClick = onDismiss) {
                        Text(stringResource(Res.string.action_cancel))
                    }
                    Button(
                        onClick = {
                            onSubmit(selectedPreset)
                        }
                    ) {
                        Text(stringResource(Res.string.apply))
                    }
                }
            }
        }
    }
}

