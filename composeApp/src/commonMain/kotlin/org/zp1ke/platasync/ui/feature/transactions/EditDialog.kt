package org.zp1ke.platasync.ui.feature.transactions

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
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.MoneyField
import org.zp1ke.platasync.ui.input.SelectTransactionType
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.randomId
import platasync.composeapp.generated.resources.*
import java.time.OffsetDateTime

@Composable
@Preview
fun TransactionEditDialog(
    transaction: UserTransaction? = null,
    showDialog: Boolean = true,
    onDismiss: () -> Unit = {},
    onSubmit: (UserTransaction) -> Unit = { _ -> },
) {
    var accountId by remember(transaction) { mutableStateOf(transaction?.accountId) }
    var categoryId by remember(transaction) { mutableStateOf(transaction?.categoryId) }
    var description by remember(transaction) { mutableStateOf(transaction?.description ?: "") }
    var amount by remember(transaction) { mutableIntStateOf(transaction?.amount ?: 0) }
    var transactionType by remember(transaction) {
        mutableStateOf(
            transaction?.transactionType ?: TransactionType.EXPENSE
        )
    }
    var datetime by remember(transaction) {
        mutableStateOf(
            transaction?.datetime ?: OffsetDateTime.now()
        )
    }

    fun checkValid(): Boolean {
        return amount > 0 && accountId != null && categoryId != null
    }

    var isValid by remember(
        transaction,
        accountId,
        categoryId,
        amount,
        transactionType,
        datetime,
    ) { mutableStateOf(checkValid()) }

    fun onClose() {
        accountId = null
        categoryId = null
        description = ""
        amount = 0
        transactionType = TransactionType.EXPENSE
        datetime = OffsetDateTime.now()
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
                            if (transaction == null)
                                Res.string.transaction_add else Res.string.transaction_edit
                        ),
                        style = MaterialTheme.typography.titleLarge
                    )

                    SelectTransactionType(
                        selectedType = transactionType,
                        onChanged = {
                            transactionType = it
                            isValid = checkValid()
                        }
                    )

                    MoneyField(
                        value = amount,
                        onValueChange = {
                            amount = it
                            isValid = checkValid()
                        },
                        label = stringResource(Res.string.transaction_amount),
                        modifier = Modifier
                            .widthIn(max = 200.dp)
                            .align(Alignment.End)
                    )

                    OutlinedTextField(
                        value = description,
                        onValueChange = {
                            description = it
                            isValid = checkValid()
                        },
                        label = { Text(stringResource(Res.string.transaction_description)) },
                        modifier = Modifier.fillMaxWidth()
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
                                val id = transaction?.id ?: randomId()
                                val createdAt = transaction?.createdAt ?: OffsetDateTime.now()
                                onSubmit(
                                    UserTransaction(
                                        id,
                                        createdAt,
                                        accountId!!,
                                        null,
                                        categoryId,
                                        description,
                                        amount,
                                        transactionType,
                                        datetime,
                                    )
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
