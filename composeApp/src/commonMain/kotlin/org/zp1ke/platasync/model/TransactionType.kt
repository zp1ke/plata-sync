package org.zp1ke.platasync.model

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Money
import androidx.compose.material.icons.filled.MoneyOff
import androidx.compose.material.icons.filled.TransferWithinAStation
import androidx.compose.ui.graphics.vector.ImageVector
import org.jetbrains.compose.resources.StringResource
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.transaction_type_expense
import platasync.composeapp.generated.resources.transaction_type_income
import platasync.composeapp.generated.resources.transaction_type_transfer

enum class TransactionType {
    INCOME {
        override fun resource(): ImageVector = Icons.Filled.Money

        override fun title(): StringResource = Res.string.transaction_type_income
    },
    EXPENSE {
        override fun resource(): ImageVector = Icons.Filled.MoneyOff

        override fun title(): StringResource = Res.string.transaction_type_expense
    },
    TRANSFER {
        override fun resource(): ImageVector = Icons.Filled.TransferWithinAStation

        override fun title(): StringResource = Res.string.transaction_type_transfer
    };

    abstract fun resource(): ImageVector

    abstract fun title(): StringResource
}
