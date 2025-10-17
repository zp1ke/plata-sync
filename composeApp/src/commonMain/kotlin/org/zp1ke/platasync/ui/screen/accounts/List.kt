package org.zp1ke.platasync.ui.screen.accounts

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DeleteForever
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.common.AppIcon
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.formatAsMoney
import org.zp1ke.platasync.util.randomId
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.account_delete
import platasync.composeapp.generated.resources.account_edit
import platasync.composeapp.generated.resources.accounts_empty

@Composable
@Preview
fun AccountsList(
    accounts: List<UserAccount> = listOf(
        UserAccount(randomId(), "Savings", AppIcon.ACCOUNT_PIGGY, 15000),
        UserAccount(randomId(), "Credit Card", AppIcon.ACCOUNT_CARD, 50000),
    ),
    onView: (UserAccount) -> Unit = { _ -> },
    onEdit: (UserAccount) -> Unit = { _ -> },
    onDelete: (UserAccount) -> Unit = { _ -> },
) {
    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(Spacing.small),
        modifier = Modifier.padding(horizontal = Spacing.small),
    ) {
        items(
            items = accounts,
            key = { it.id },
        ) { account ->
            AccountListItem(
                account = account,
                onView = { onView(account) },
                onEdit = { onEdit(account) },
                onDelete = { onDelete(account) },
            )
        }

        if (accounts.isEmpty()) {
            item {
                Spacer(modifier = Modifier.height(Size.iconLarge))
                Text(
                    text = stringResource(Res.string.accounts_empty),
                    style = MaterialTheme.typography.titleLarge
                        .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                    textAlign = TextAlign.Center,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = Spacing.medium),
                )
            }
        }
    }
}

@Composable
private fun AccountListItem(
    account: UserAccount,
    onView: () -> Unit = {},
    onEdit: () -> Unit = {},
    onDelete: () -> Unit = {},
) {
    ListItem(
        modifier = Modifier
            .clip(MaterialTheme.shapes.small)
            .clickable { onView() }
            .padding(horizontal = Spacing.small),
        colors = ListItemDefaults.colors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        headlineContent = {
            Text(
                text = account.name,
                style = MaterialTheme.typography.titleMedium
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
            )
        },
        supportingContent = {
            Text(
                text = account.balance.formatAsMoney(),
                style = MaterialTheme.typography.bodySmall
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant, fontWeight = FontWeight.W500),
            )
        },
        leadingContent = {
            ImageIcon(account.icon)
        },
        trailingContent = {
            Row {
                IconButton(onClick = { onEdit() }) {
                    Icon(
                        imageVector = Icons.Filled.Edit,
                        contentDescription = stringResource(Res.string.account_edit),
                        modifier = Modifier.width(Size.iconSmall),
                    )
                }
                IconButton(onClick = { onDelete() }) {
                    Icon(
                        imageVector = Icons.Filled.DeleteForever,
                        contentDescription = stringResource(Res.string.account_delete),
                        modifier = Modifier.width(Size.iconSmall),
                    )
                }
            }
        },
    )
}