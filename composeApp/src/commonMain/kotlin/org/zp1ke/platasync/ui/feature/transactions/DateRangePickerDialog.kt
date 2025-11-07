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
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.formatAsDate
import platasync.composeapp.generated.resources.*
import java.time.LocalTime
import java.time.OffsetDateTime

enum class DateRangePreset(val key: String) {
    TODAY("today"),
    YESTERDAY("yesterday"),
    LAST_7_DAYS("last_7_days"),
    LAST_30_DAYS("last_30_days"),
    THIS_MONTH("this_month"),
    LAST_MONTH("last_month")
}

@Composable
fun DateRangePickerDialog(
    showDialog: Boolean = false,
    currentFrom: OffsetDateTime,
    currentTo: OffsetDateTime,
    onDismiss: () -> Unit = {},
    onSubmit: (from: OffsetDateTime, to: OffsetDateTime) -> Unit = { _, _ -> },
) {
    if (!showDialog) return

    val now = remember { OffsetDateTime.now() }

    // Determine initial preset based on current date range
    val initialPreset = remember(currentFrom, currentTo) {
        val fromLocal = currentFrom.toLocalDate()
        val toLocal = currentTo.toLocalDate()
        val nowLocal = now.toLocalDate()

        when {
            // Check if it's today
            fromLocal.equals(nowLocal) && toLocal.equals(nowLocal) -> DateRangePreset.TODAY

            // Check if it's yesterday
            fromLocal.equals(nowLocal.minusDays(1)) && toLocal.equals(nowLocal.minusDays(1)) -> DateRangePreset.YESTERDAY

            // Check if it's last 7 days
            fromLocal.equals(nowLocal.minusDays(6)) && toLocal.equals(nowLocal) -> DateRangePreset.LAST_7_DAYS

            // Check if it's last 30 days
            fromLocal.equals(nowLocal.minusDays(29)) && toLocal.equals(nowLocal) -> DateRangePreset.LAST_30_DAYS

            // Check if it's this month
            fromLocal.equals(nowLocal.withDayOfMonth(1)) && toLocal.equals(nowLocal) -> DateRangePreset.THIS_MONTH

            // Check if it's last month
            else -> {
                val lastMonth = nowLocal.minusMonths(1)
                val firstDay = lastMonth.withDayOfMonth(1)
                val lastDay = firstDay.plusMonths(1).minusDays(1)
                if (fromLocal.equals(firstDay) && toLocal.equals(lastDay)) {
                    DateRangePreset.LAST_MONTH
                } else {
                    // Default to TODAY if no preset matches
                    DateRangePreset.TODAY
                }
            }
        }
    }

    var selectedPreset by remember(showDialog) {
        mutableStateOf(initialPreset)
    }

    var fromDate by remember(showDialog) { mutableStateOf(currentFrom) }
    var toDate by remember(showDialog) { mutableStateOf(currentTo) }

    // Update dates when preset changes
    LaunchedEffect(selectedPreset) {
        when (selectedPreset) {
            DateRangePreset.TODAY -> {
                fromDate = OffsetDateTime.of(now.toLocalDate().atStartOfDay(), now.offset)
                toDate = OffsetDateTime.of(now.toLocalDate().atTime(LocalTime.MAX), now.offset)
            }

            DateRangePreset.YESTERDAY -> {
                val yesterday = now.minusDays(1)
                fromDate = OffsetDateTime.of(yesterday.toLocalDate().atStartOfDay(), now.offset)
                toDate = OffsetDateTime.of(yesterday.toLocalDate().atTime(LocalTime.MAX), now.offset)
            }

            DateRangePreset.LAST_7_DAYS -> {
                fromDate = OffsetDateTime.of(now.minusDays(6).toLocalDate().atStartOfDay(), now.offset)
                toDate = OffsetDateTime.of(now.toLocalDate().atTime(LocalTime.MAX), now.offset)
            }

            DateRangePreset.LAST_30_DAYS -> {
                fromDate = OffsetDateTime.of(now.minusDays(29).toLocalDate().atStartOfDay(), now.offset)
                toDate = OffsetDateTime.of(now.toLocalDate().atTime(LocalTime.MAX), now.offset)
            }

            DateRangePreset.THIS_MONTH -> {
                fromDate = OffsetDateTime.of(now.toLocalDate().withDayOfMonth(1).atStartOfDay(), now.offset)
                toDate = OffsetDateTime.of(now.toLocalDate().atTime(LocalTime.MAX), now.offset)
            }

            DateRangePreset.LAST_MONTH -> {
                val lastMonth = now.minusMonths(1)
                val firstDay = lastMonth.toLocalDate().withDayOfMonth(1)
                val lastDay = firstDay.plusMonths(1).minusDays(1)
                fromDate = OffsetDateTime.of(firstDay.atStartOfDay(), now.offset)
                toDate = OffsetDateTime.of(lastDay.atTime(LocalTime.MAX), now.offset)
            }
        }
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
                                text = when (preset) {
                                    DateRangePreset.TODAY -> stringResource(Res.string.date_range_today)
                                    DateRangePreset.YESTERDAY -> stringResource(Res.string.date_range_yesterday)
                                    DateRangePreset.LAST_7_DAYS -> stringResource(Res.string.date_range_last_7_days)
                                    DateRangePreset.LAST_30_DAYS -> stringResource(Res.string.date_range_last_30_days)
                                    DateRangePreset.THIS_MONTH -> stringResource(Res.string.date_range_this_month)
                                    DateRangePreset.LAST_MONTH -> stringResource(Res.string.date_range_last_month)
                                },
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
                            onSubmit(fromDate, toDate)
                        }
                    ) {
                        Text(stringResource(Res.string.apply))
                    }
                }
            }
        }
    }
}

