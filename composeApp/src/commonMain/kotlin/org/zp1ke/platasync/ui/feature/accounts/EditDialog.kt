package org.zp1ke.platasync.ui.feature.accounts

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.common.AppIcon
import org.zp1ke.platasync.ui.common.AppIconType
import org.zp1ke.platasync.ui.common.MoneyField
import org.zp1ke.platasync.ui.form.SelectIcon
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.randomId
import platasync.composeapp.generated.resources.*
import java.time.OffsetDateTime

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
    var initialBalance by remember(account) { mutableIntStateOf(account?.initialBalance ?: 0) }

    fun checkValid(): Boolean {
        return name.isNotBlank() && initialBalance >= 0
    }

    var isValid by remember(account, name, initialBalance) { mutableStateOf(checkValid()) }

    fun onClose() {
        name = ""
        icon = AppIcon.ACCOUNT_BANK
        initialBalance = 0
        isValid = false
        onDismiss()
    }

    if (showDialog) {
        Dialog(
            onDismissRequest = onDismiss,
            properties = DialogProperties(usePlatformDefaultWidth = false)
        ) {
            Surface(
                shape = MaterialTheme.shapes.medium,
                color = MaterialTheme.colorScheme.background,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = Spacing.medium)
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
                            options = AppIcon.listByType(AppIconType.ACCOUNT),
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
                        value = initialBalance,
                        onValueChange = {
                            // TODO: recalculate balance based on existing transactions?
                            initialBalance = it
                            isValid = checkValid()
                        },
                        label = stringResource(Res.string.account_initial_balance),
                        modifier = Modifier
                            .widthIn(max = 200.dp)
                            .align(Alignment.End)
                    )

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End
                    ) {
                        TextButton(onClick = { onClose() }) {
                            Text(stringResource(Res.string.action_cancel))
                        }
                        TextButton(
                            onClick = {
                                val id = account?.id ?: randomId()
                                val createdAt = account?.createdAt ?: OffsetDateTime.now()
                                onSubmit(
                                    UserAccount(id, createdAt, name, icon, initialBalance)
                                )
                                onClose()
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
