package org.zp1ke.platasync.model

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Money
import androidx.compose.material.icons.filled.MoneyOff
import androidx.compose.material.icons.filled.TransferWithinAStation
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import org.jetbrains.compose.resources.StringResource
import org.zp1ke.platasync.ui.theme.*
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.transaction_type_expense
import platasync.composeapp.generated.resources.transaction_type_income
import platasync.composeapp.generated.resources.transaction_type_transfer

enum class TransactionType {
    INCOME {
        override fun icon(): ImageVector = Icons.Filled.Money

        override fun title(): StringResource = Res.string.transaction_type_income

        override fun color(isDarkMode: Boolean): Color = if (isDarkMode) incomeDark else incomeLight
    },
    EXPENSE {
        override fun icon(): ImageVector = Icons.Filled.MoneyOff

        override fun title(): StringResource = Res.string.transaction_type_expense

        override fun color(isDarkMode: Boolean): Color = if (isDarkMode) expenseDark else expenseLight
    },
    TRANSFER {
        override fun icon(): ImageVector = Icons.Filled.TransferWithinAStation

        override fun title(): StringResource = Res.string.transaction_type_transfer

        override fun color(isDarkMode: Boolean): Color = if (isDarkMode) transferDark else transferLight
    };

    abstract fun icon(): ImageVector

    abstract fun title(): StringResource

    abstract fun color(isDarkMode: Boolean): Color
}
