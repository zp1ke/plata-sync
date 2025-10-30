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
import org.koin.compose.koinInject
import org.koin.core.qualifier.named
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.data.repository.DaoCategoriesRepository
import org.zp1ke.platasync.domain.UserCategory
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.common.MoneyField
import org.zp1ke.platasync.ui.input.SelectAccount
import org.zp1ke.platasync.ui.input.SelectCategory
import org.zp1ke.platasync.ui.input.SelectTargetAccount
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
    categoryRepository: BaseRepository<UserCategory> = koinInject(named(DaoCategoriesRepository.KEY))
) {
    var accountId by remember(transaction) { mutableStateOf(transaction?.accountId) }
    var targetAccountId by remember(transaction) { mutableStateOf(transaction?.targetAccountId) }
    var categoryId by remember(transaction) { mutableStateOf(transaction?.categoryId) }
    var selectedCategoryTransactionTypes by remember { mutableStateOf<List<TransactionType>>(emptyList()) }
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

    // Track selected category's transaction types
    LaunchedEffect(categoryId) {
        if (categoryId != null) {
            val category = categoryRepository.getItemById(categoryId!!)
            selectedCategoryTransactionTypes = category?.transactionTypes ?: emptyList()
        } else {
            selectedCategoryTransactionTypes = emptyList()
        }
    }

    // Clear categoryId if transaction type changes and is not compatible with selected category
    LaunchedEffect(transactionType, selectedCategoryTransactionTypes) {
        if (categoryId != null && selectedCategoryTransactionTypes.isNotEmpty()) {
            if (!selectedCategoryTransactionTypes.contains(transactionType)) {
                categoryId = null
            }
        }
    }

    // Clear categoryId/targetAccountId when switching between TRANSFER and other types
    LaunchedEffect(transactionType) {
        if (transactionType == TransactionType.TRANSFER) {
            categoryId = null
        } else {
            targetAccountId = null
        }
    }

    // Clear targetAccountId if it matches the source accountId
    LaunchedEffect(accountId, targetAccountId) {
        if (accountId != null && targetAccountId != null && accountId == targetAccountId) {
            targetAccountId = null
        }
    }

    fun checkValid(): Boolean {
        return amount > 0 && accountId != null &&
                if (transactionType == TransactionType.TRANSFER) {
                    targetAccountId != null && targetAccountId != accountId
                } else {
                    categoryId != null
                }
    }

    var isValid by remember(
        transaction,
        accountId,
        targetAccountId,
        categoryId,
        amount,
        transactionType,
        datetime,
    ) { mutableStateOf(checkValid()) }

    fun onClose() {
        accountId = null
        targetAccountId = null
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

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(Spacing.small)
                    ) {
                        SelectAccount(
                            selectedAccountId = accountId,
                            onAccountSelected = { account ->
                                accountId = account.id
                                isValid = checkValid()
                            },
                            modifier = Modifier.weight(1f)
                        )

                        if (transactionType == TransactionType.TRANSFER) {
                            SelectTargetAccount(
                                selectedTargetAccountId = targetAccountId,
                                excludeAccountId = accountId,
                                onAccountSelected = { account ->
                                    targetAccountId = account.id
                                    isValid = checkValid()
                                },
                                modifier = Modifier.weight(1f)
                            )
                        } else {
                            SelectCategory(
                                selectedCategoryId = categoryId,
                                transactionType = transactionType,
                                onCategorySelected = { category ->
                                    categoryId = category.id
                                    isValid = checkValid()
                                },
                                modifier = Modifier.weight(1f)
                            )
                        }
                    }

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
                                        targetAccountId,
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
