package org.zp1ke.platasync.model

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Money
import androidx.compose.material.icons.filled.MoneyOff
import androidx.compose.material.icons.filled.TransferWithinAStation
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import org.jetbrains.compose.resources.StringResource
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.transaction_type_expense
import platasync.composeapp.generated.resources.transaction_type_income
import platasync.composeapp.generated.resources.transaction_type_transfer

enum class TransactionType {
    INCOME {
        override fun icon(): ImageVector = Icons.Filled.Money

        override fun title(): StringResource = Res.string.transaction_type_income

        override fun color(isDarkMode: Boolean): Color = if (isDarkMode) {
            Color(0xFF4CAF50) // Lighter green for dark mode
        } else {
            Color(0xFF2E7D32) // Darker green for light mode
        }
    },
    EXPENSE {
        override fun icon(): ImageVector = Icons.Filled.MoneyOff

        override fun title(): StringResource = Res.string.transaction_type_expense

        override fun color(isDarkMode: Boolean): Color = if (isDarkMode) {
            Color(0xFFEF5350) // Lighter red for dark mode
        } else {
            Color(0xFFC62828) // Darker red for light mode
        }
    },
    TRANSFER {
        override fun icon(): ImageVector = Icons.Filled.TransferWithinAStation

        override fun title(): StringResource = Res.string.transaction_type_transfer

        override fun color(isDarkMode: Boolean): Color = if (isDarkMode) {
            Color(0xFF42A5F5) // Lighter blue for dark mode
        } else {
            Color(0xFF1976D2) // Darker blue for light mode
        }
    };

    abstract fun icon(): ImageVector

    abstract fun title(): StringResource

    abstract fun color(isDarkMode: Boolean): Color
}
