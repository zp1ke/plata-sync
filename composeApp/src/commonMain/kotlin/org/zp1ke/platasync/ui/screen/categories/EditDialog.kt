package org.zp1ke.platasync.ui.screen.categories

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.UserCategory
import org.zp1ke.platasync.ui.common.AppIcon
import org.zp1ke.platasync.ui.common.AppIconType
import org.zp1ke.platasync.ui.form.SelectIcon
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.randomId
import platasync.composeapp.generated.resources.*
import java.time.OffsetDateTime

@Composable
@Preview
fun CategoryEditDialog(
    category: UserCategory? = null,
    showDialog: Boolean = true,
    onDismiss: () -> Unit = {},
    onSubmit: (UserCategory) -> Unit = { _ -> },
) {
    var name by remember(category) { mutableStateOf(category?.name ?: "") }
    var icon by remember(category) { mutableStateOf(category?.icon ?: AppIcon.CATEGORY_HOME) }

    fun checkValid(): Boolean {
        return name.isNotBlank()
    }

    var isValid by remember(category, name) { mutableStateOf(checkValid()) }

    fun onClose() {
        name = ""
        icon = AppIcon.CATEGORY_HOME
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
                            if (category == null)
                                Res.string.category_add else Res.string.category_edit
                        ),
                        style = MaterialTheme.typography.titleLarge
                    )

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End
                    ) {
                        SelectIcon(
                            value = icon,
                            options = AppIcon.listByType(AppIconType.CATEGORY),
                            onChanged = { icon = it },
                        )

                        OutlinedTextField(
                            value = name,
                            onValueChange = {
                                name = it
                                isValid = checkValid()
                            },
                            label = { Text(stringResource(Res.string.category_name) + '*') },
                            modifier = Modifier.fillMaxWidth()
                        )
                    }

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End
                    ) {
                        TextButton(onClick = { onClose() }) {
                            Text(stringResource(Res.string.action_cancel))
                        }
                        TextButton(
                            onClick = {
                                val id = category?.id ?: randomId()
                                val createdAt = category?.createdAt ?: OffsetDateTime.now()
                                onSubmit(
                                    UserCategory(id, createdAt, name, icon, listOf()) // TODO: transaction types
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
