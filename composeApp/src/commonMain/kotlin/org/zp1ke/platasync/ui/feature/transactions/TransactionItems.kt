package org.zp1ke.platasync.ui.feature.transactions

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DeleteForever
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.data.model.UserFullTransaction
import org.zp1ke.platasync.domain.UserCategory
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.BaseItem
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.common.ViewMode
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.formatAsDateTime
import org.zp1ke.platasync.util.formatAsMoney
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.transaction_delete
import platasync.composeapp.generated.resources.transaction_edit

@Composable
fun TransactionItem(
    transaction: UserFullTransaction,
    viewMode: ViewMode,
    actions: ItemActions<UserFullTransaction>,
    enabled: Boolean,
) {
    val isDarkMode = isSystemInDarkTheme()

    when (viewMode) {
        ViewMode.LIST -> {
            BaseItem(
                viewMode = viewMode,
                enabled = enabled,
                onView = { actions.onView(transaction) },
                onEdit = { actions.onEdit(transaction) },
                onDelete = { actions.onDelete(transaction) },
                editStringResource = Res.string.transaction_edit,
                deleteStringResource = Res.string.transaction_delete,
                leadingContent = {
                    TransactionTypeIcon(transaction.transactionType, isDarkMode)
                },
                headlineContent = {
                    TransactionHeadline(transaction = transaction, inlineCategory = true)
                },
                supportingContent = {
                    TransactionSupporting(transaction = transaction, isDarkMode = isDarkMode)
                }
            )
        }

        ViewMode.GRID -> {
            TransactionGridItem(
                transaction = transaction,
                actions = actions,
                enabled = enabled,
                isDarkMode = isDarkMode
            )
        }
    }
}

@Composable
private fun TransactionGridItem(
    transaction: UserFullTransaction,
    actions: ItemActions<UserFullTransaction>,
    enabled: Boolean,
    isDarkMode: Boolean,
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        onClick = { actions.onView(transaction) },
        enabled = enabled,
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(Spacing.medium),
            verticalArrangement = Arrangement.spacedBy(Spacing.small)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(Spacing.small)
            ) {
                TransactionTypeIcon(transaction.transactionType, isDarkMode)
                Spacer(modifier = Modifier.weight(1f))
                IconButton(onClick = { actions.onEdit(transaction) }, enabled = enabled) {
                    Icon(
                        imageVector = Icons.Filled.Edit,
                        contentDescription = stringResource(Res.string.transaction_edit),
                        modifier = Modifier.width(Size.iconSmall),
                    )
                }
                IconButton(onClick = { actions.onDelete(transaction) }, enabled = enabled) {
                    Icon(
                        imageVector = Icons.Filled.DeleteForever,
                        contentDescription = stringResource(Res.string.transaction_delete),
                        modifier = Modifier.width(Size.iconSmall),
                    )
                }
            }
            TransactionHeadline(transaction = transaction, inlineCategory = false, iconSize = Size.iconMedium)
            TransactionSupporting(transaction = transaction, isDarkMode = isDarkMode)
        }
    }
}

@Composable
private fun TransactionHeadline(
    transaction: UserFullTransaction,
    inlineCategory: Boolean = true,
    iconSize: Dp = Size.iconSmall,
) {
    Column(modifier = Modifier.fillMaxWidth()) {
        Row(modifier = Modifier.fillMaxWidth()) {
            ImageIcon(
                transaction.account.icon,
                width = iconSize,
                modifier = Modifier.alignByBaseline(),
            )
            Text(
                text = transaction.account.name,
                style = MaterialTheme.typography.titleMedium
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                modifier = Modifier.alignByBaseline()
            )
            Text(
                text = " • ${transaction.transaction.datetime.formatAsDateTime()}",
                style = MaterialTheme.typography.bodySmall
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                modifier = Modifier.alignByBaseline()
            )
            Spacer(modifier = Modifier.weight(1f))
            if (inlineCategory && transaction.category != null) {
                TransactionCategoryInfo(
                    category = transaction.category,
                    modifier = Modifier.alignByBaseline(),
                    iconSize = iconSize,
                )
            }
        }
        if (!inlineCategory && transaction.category != null) {
            TransactionCategoryInfo(
                category = transaction.category,
                modifier = Modifier
                    .padding(top = Spacing.small)
                    .fillMaxWidth(),
                iconSize = iconSize,
            )
        }
    }
}

@Composable
private fun TransactionCategoryInfo(
    category: UserCategory,
    modifier: Modifier = Modifier,
    iconSize: Dp = Size.iconSmall,
) {
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(Spacing.small)
    ) {
        ImageIcon(
            category.icon,
            width = iconSize,
        )
        Text(
            text = category.name,
            style = MaterialTheme.typography.titleSmall
                .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
        )
    }
}

@Composable
private fun TransactionSupporting(
    transaction: UserFullTransaction,
    isDarkMode: Boolean,
) {
    Row(modifier = Modifier.fillMaxWidth()) {
        Text(
            text = transaction.signedAmount.formatAsMoney(),
            style = MaterialTheme.typography.bodyMedium
                .copy(
                    color = transaction.transactionType.color(isDarkMode),
                    fontWeight = FontWeight.W500
                ),
            modifier = Modifier
                .alignByBaseline()
                .fillMaxWidth(0.25f),
            textAlign = TextAlign.End,
        )
        Text(
            text = " = ",
            style = MaterialTheme.typography.bodyMedium,
            modifier = Modifier.alignByBaseline(),
        )
        Text(
            text = transaction.transaction.accountBalanceAfter.formatAsMoney(),
            style = MaterialTheme.typography.bodyMedium
                .copy(fontWeight = FontWeight.W500),
            modifier = Modifier.alignByBaseline(),
        )
        Spacer(modifier = Modifier.weight(1f))
        if (!transaction.transaction.description.isNullOrBlank()) {
            Text(
                text = transaction.transaction.description,
                style = MaterialTheme.typography.bodySmall
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                modifier = Modifier
                    .weight(1f)
                    .alignByBaseline()
            )
        }
    }
}

@Composable
private fun TransactionTypeIcon(
    transactionType: TransactionType,
    isDarkMode: Boolean,
) {
    Icon(
        imageVector = transactionType.icon(),
        contentDescription = null,
        tint = transactionType.color(isDarkMode),
        modifier = Modifier.size(Size.iconSmall)
    )
}

