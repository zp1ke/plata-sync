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

        override fun color(): Color = Color(0xFF4CAF50)
    },
    EXPENSE {
        override fun icon(): ImageVector = Icons.Filled.MoneyOff

        override fun title(): StringResource = Res.string.transaction_type_expense

        override fun color(): Color = Color(0xFFF44336)
    },
    TRANSFER {
        override fun icon(): ImageVector = Icons.Filled.TransferWithinAStation

        override fun title(): StringResource = Res.string.transaction_type_transfer

        override fun color(): Color = Color(0xFF2196F3)
    };

    abstract fun icon(): ImageVector

    abstract fun title(): StringResource

    abstract fun color(): Color
}
