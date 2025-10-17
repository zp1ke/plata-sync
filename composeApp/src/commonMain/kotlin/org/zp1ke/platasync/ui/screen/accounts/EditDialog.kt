package org.zp1ke.platasync.ui.form

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.common.AppIcon
import org.zp1ke.platasync.ui.common.MoneyField
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.randomId
import platasync.composeapp.generated.resources.*

@Composable
@Preview
fun AccountEditDialog(
    account: UserAccount? = null,
    showDialog: Boolean = true,
    onDismiss: () -> Unit = {},
    onSubmit: (UserAccount) -> Unit = { _ -> },
) {
    var name by remember(account) { mutableStateOf(account?.name ?: "") }
    var icon by remember(account) { mutableStateOf(account?.icon ?: AppIcon.ACCOUNT_BANK) }
    var balance by remember(account) { mutableIntStateOf(account?.balance ?: 0) }

    fun checkValid(): Boolean {
        return name.isNotBlank() && balance >= 0
    }

    var isValid by remember(account, name, balance) { mutableStateOf(checkValid()) }

    if (showDialog) {
        Dialog(onDismissRequest = onDismiss) {
            Surface(
                shape = MaterialTheme.shapes.medium,
                color = MaterialTheme.colorScheme.background,
                modifier = Modifier.padding(Spacing.medium)
            ) {
                Column(
                    modifier = Modifier.padding(Spacing.medium),
                    verticalArrangement = Arrangement.spacedBy(Spacing.small)
                ) {
                    Text(
                        text = stringResource(
                            if (account == null)
                                Res.string.account_add else Res.string.account_edit
                        ),
                        style = MaterialTheme.typography.titleLarge
                    )

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End
                    ) {
                        SelectIcon(
                            value = icon,
                            options = listOf(
                                AppIcon.ACCOUNT_BANK,
                                AppIcon.ACCOUNT_CARD,
                                AppIcon.ACCOUNT_PIGGY,
                            ),
                            onChanged = { icon = it },
                        )

                        OutlinedTextField(
                            value = name,
                            onValueChange = {
                                name = it
                                isValid = checkValid()
                            },
                            label = { Text(stringResource(Res.string.account_name) + '*') },
                            modifier = Modifier.fillMaxWidth()
                        )
                    }

                    MoneyField(
                        value = balance,
                        onValueChange = {
                            balance = it
                            isValid = checkValid()
                        },
                        label = stringResource(Res.string.account_balance),
                        modifier = Modifier
                            .widthIn(max = 200.dp)
                            .align(Alignment.End)
                    )

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End
                    ) {
                        TextButton(onClick = onDismiss) {
                            Text(stringResource(Res.string.action_cancel))
                        }
                        TextButton(
                            onClick = {
                                val id = account?.id ?: randomId()
                                onSubmit(
                                    UserAccount(id, name, icon, balance)
                                )
                                onDismiss()
                            },
                            enabled = isValid,
                        ) {
                            Text(stringResource(Res.string.action_save))
                        }
                    }
                }
            }
        }
    }
}
