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
import org.zp1ke.platasync.data.repository.DaoAccountsRepository
import org.zp1ke.platasync.data.repository.DaoCategoriesRepository
import org.zp1ke.platasync.domain.UserAccount
import org.zp1ke.platasync.domain.UserCategory
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.input.*
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
    accountRepository: BaseRepository<UserAccount> = koinInject(named(DaoAccountsRepository.KEY)),
    categoryRepository: BaseRepository<UserCategory> = koinInject(named(DaoCategoriesRepository.KEY))
) {
    var account: UserAccount? by remember(transaction) { mutableStateOf(null) }
    var targetAccount: UserAccount? by remember(transaction) { mutableStateOf(null) }
    var category: UserCategory? by remember(transaction) { mutableStateOf(null) }
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
    LaunchedEffect(category) {
        selectedCategoryTransactionTypes = if (category != null) {
            category?.transactionTypes ?: emptyList()
        } else {
            emptyList()
        }
    }

    // Clear categoryId if transaction type changes and is not compatible with selected category
    LaunchedEffect(transactionType, selectedCategoryTransactionTypes) {
        if (category != null && selectedCategoryTransactionTypes.isNotEmpty()) {
            if (!selectedCategoryTransactionTypes.contains(transactionType)) {
                category = null
            }
        }
    }

    // Clear categoryId/targetAccountId when switching between TRANSFER and other types
    LaunchedEffect(transactionType) {
        if (transactionType == TransactionType.TRANSFER) {
            category = null
        } else {
            targetAccount = null
        }
    }

    // Clear targetAccountId if it matches the source accountId
    LaunchedEffect(account, targetAccount) {
        if (account != null && targetAccount != null && account?.id == targetAccount?.id) {
            targetAccount = null
        }
    }

    // Load initial account, targetAccount, category
    LaunchedEffect(transaction) {
        if (transaction != null) {
            account = accountRepository.getItemById(transaction.accountId)
            targetAccount = transaction.targetAccountId?.let {
                accountRepository.getItemById(it)
            }
            category = transaction.categoryId?.let {
                categoryRepository.getItemById(it)
            }
        }
    }

    fun checkValid(): Boolean {
        return amount > 0 && account != null &&
                if (transactionType == TransactionType.TRANSFER) {
                    targetAccount != null && targetAccount?.id != account?.id
                } else {
                    category != null
                }
    }

    var isValid by remember(
        transaction,
        account,
        targetAccount,
        category,
        amount,
        transactionType,
        datetime,
    ) { mutableStateOf(checkValid()) }

    fun onClose() {
        account = null
        targetAccount = null
        category = null
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
                            selectedAccountId = account?.id,
                            onAccountSelected = { selectedAccount ->
                                account = selectedAccount
                                isValid = checkValid()
                            },
                            modifier = Modifier.weight(1f)
                        )

                        if (transactionType == TransactionType.TRANSFER) {
                            SelectTargetAccount(
                                selectedTargetAccountId = targetAccount?.id,
                                excludeAccountId = account?.id,
                                onAccountSelected = { selectedAccount ->
                                    targetAccount = selectedAccount
                                    isValid = checkValid()
                                },
                                modifier = Modifier.weight(1f)
                            )
                        } else {
                            SelectCategory(
                                selectedCategoryId = category?.id,
                                transactionType = transactionType,
                                onCategorySelected = { selectedCategory ->
                                    category = selectedCategory
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
                                        account?.id!!,
                                        targetAccount?.id,
                                        category?.id,
                                        description,
                                        amount,
                                        transactionType,
                                        datetime,
                                        account!!.balanceAfter(amount, transactionType),
                                        targetAccount?.balanceAfter(amount, transactionType),
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
