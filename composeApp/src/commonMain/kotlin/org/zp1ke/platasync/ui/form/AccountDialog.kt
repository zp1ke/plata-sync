package org.zp1ke.platasync.ui.form

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.AppIcon
import org.zp1ke.platasync.model.UserAccount

@Composable
@Preview
fun AccountDialog(
    showDialog: Boolean,
    onDismiss: () -> Unit,
    onSubmit: (UserAccount) -> Unit
) {
    if (showDialog) {
        Dialog(onDismissRequest = onDismiss) {
            Surface(
                shape = MaterialTheme.shapes.medium,
                color = MaterialTheme.colorScheme.background,
                modifier = Modifier.padding(16.dp)
            ) {
                Column(
                    modifier = Modifier.padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Text(
                        text = "Fill the Form",
                        style = MaterialTheme.typography.titleMedium
                    )

                    var name by remember { mutableStateOf("") }
                    var icon by remember { mutableStateOf(AppIcon.ACCOUNT_BANK) }

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
                            onValueChange = { name = it },
                            label = { Text("Name") },
                            modifier = Modifier.fillMaxWidth()
                        )
                    }

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End
                    ) {
                        TextButton(onClick = onDismiss) {
                            Text("Cancel")
                        }
                        TextButton(onClick = {
                            onSubmit(UserAccount(
                                id = name,
                                name = name,
                                icon = icon,
                                balance = 0,
                            ))
                            onDismiss()
                        }) {
                            Text("Submit")
                        }
                    }
                }
            }
        }
    }
}
