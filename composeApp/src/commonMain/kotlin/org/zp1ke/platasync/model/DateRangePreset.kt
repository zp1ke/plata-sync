package org.zp1ke.platasync.model

import androidx.compose.runtime.Composable
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource
import platasync.composeapp.generated.resources.*
import java.time.LocalTime
import java.time.OffsetDateTime

enum class DateRangePreset(val key: String) {
    TODAY("today"),
    YESTERDAY("yesterday"),
    LAST_7_DAYS("last_7_days"),
    LAST_30_DAYS("last_30_days"),
    THIS_MONTH("this_month"),
    LAST_MONTH("last_month");

    /**
     * Get the string resource for this preset
     */
    fun getStringResource(): StringResource = when (this) {
        TODAY -> Res.string.date_range_today
        YESTERDAY -> Res.string.date_range_yesterday
        LAST_7_DAYS -> Res.string.date_range_last_7_days
        LAST_30_DAYS -> Res.string.date_range_last_30_days
        THIS_MONTH -> Res.string.date_range_this_month
        LAST_MONTH -> Res.string.date_range_last_month
    }

    /**
     * Get the localized string for this preset
     */
    @Composable
    fun getLabel(): String = stringResource(getStringResource())

    /**
     * Calculate the date range (from, to) for this preset
     */
    fun getDateRange(now: OffsetDateTime = OffsetDateTime.now()): Pair<OffsetDateTime, OffsetDateTime> {
        return when (this) {
            TODAY -> {
                val from = OffsetDateTime.of(now.toLocalDate().atStartOfDay(), now.offset)
                val to = OffsetDateTime.of(now.toLocalDate().atTime(LocalTime.MAX), now.offset)
                from to to
            }

            YESTERDAY -> {
                val yesterday = now.minusDays(1)
                val from = OffsetDateTime.of(yesterday.toLocalDate().atStartOfDay(), now.offset)
                val to = OffsetDateTime.of(yesterday.toLocalDate().atTime(LocalTime.MAX), now.offset)
                from to to
            }

            LAST_7_DAYS -> {
                val from = OffsetDateTime.of(now.minusDays(6).toLocalDate().atStartOfDay(), now.offset)
                val to = OffsetDateTime.of(now.toLocalDate().atTime(LocalTime.MAX), now.offset)
                from to to
            }

            LAST_30_DAYS -> {
                val from = OffsetDateTime.of(now.minusDays(29).toLocalDate().atStartOfDay(), now.offset)
                val to = OffsetDateTime.of(now.toLocalDate().atTime(LocalTime.MAX), now.offset)
                from to to
            }

            THIS_MONTH -> {
                val from = OffsetDateTime.of(now.toLocalDate().withDayOfMonth(1).atStartOfDay(), now.offset)
                val to = OffsetDateTime.of(now.toLocalDate().atTime(LocalTime.MAX), now.offset)
                from to to
            }

            LAST_MONTH -> {
                val lastMonth = now.minusMonths(1)
                val firstDay = lastMonth.toLocalDate().withDayOfMonth(1)
                val lastDay = firstDay.plusMonths(1).minusDays(1)
                val from = OffsetDateTime.of(firstDay.atStartOfDay(), now.offset)
                val to = OffsetDateTime.of(lastDay.atTime(LocalTime.MAX), now.offset)
                from to to
            }
        }
    }

    companion object {
        /**
         * Determine which preset matches the given date range
         * @param from The start date of the range
         * @param to The end date of the range
         * @param now The reference date for comparison (defaults to now)
         * @return The matching preset, or TODAY as default if no match is found
         */
        fun fromDateRange(
            from: OffsetDateTime,
            to: OffsetDateTime,
            now: OffsetDateTime = OffsetDateTime.now()
        ): DateRangePreset {
            val fromLocal = from.toLocalDate()
            val toLocal = to.toLocalDate()
            val nowLocal = now.toLocalDate()

            return when {
                // Check if it's today
                fromLocal.equals(nowLocal) && toLocal.equals(nowLocal) -> TODAY

                // Check if it's yesterday
                fromLocal.equals(nowLocal.minusDays(1)) && toLocal.equals(nowLocal.minusDays(1)) -> YESTERDAY

                // Check if it's last 7 days
                fromLocal.equals(nowLocal.minusDays(6)) && toLocal.equals(nowLocal) -> LAST_7_DAYS

                // Check if it's last 30 days
                fromLocal.equals(nowLocal.minusDays(29)) && toLocal.equals(nowLocal) -> LAST_30_DAYS

                // Check if it's this month
                fromLocal.equals(nowLocal.withDayOfMonth(1)) && toLocal.equals(nowLocal) -> THIS_MONTH

                // Check if it's last month
                else -> {
                    val lastMonth = nowLocal.minusMonths(1)
                    val firstDay = lastMonth.withDayOfMonth(1)
                    val lastDay = firstDay.plusMonths(1).minusDays(1)
                    if (fromLocal.equals(firstDay) && toLocal.equals(lastDay)) {
                        LAST_MONTH
                    } else {
                        // Default to TODAY if no preset matches
                        TODAY
                    }
                }
            }
        }
    }
}

