package org.zp1ke.platasync.ui.feature.accounts

import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.domain.UserAccount
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.account_delete
import platasync.composeapp.generated.resources.action_cancel
import platasync.composeapp.generated.resources.action_ok

@Composable
@Preview
fun AccountDeleteDialog(
    account: UserAccount? = null,
    showDialog: Boolean = true,
    onDismiss: () -> Unit = {},
    onSubmit: () -> Unit = {},
) {
    if (showDialog && account != null) {
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
                        text = stringResource(Res.string.account_delete),
                        style = MaterialTheme.typography.titleLarge
                    )

                    Text(
                        text = stringResource(Res.string.account_delete) + " \"" + account.name + "\"?", // TODO improve
                        style = MaterialTheme.typography.bodyMedium
                    )

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End
                    ) {
                        TextButton(onClick = onDismiss) {
                            Text(stringResource(Res.string.action_cancel))
                        }
                        TextButton(onClick = onSubmit) {
                            Text(stringResource(Res.string.action_ok))
                        }
                    }
                }
            }
        }
    }
}