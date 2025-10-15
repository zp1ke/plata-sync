package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.rememberScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import cafe.adriel.voyager.core.screen.Screen
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.painterResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.AppIcon
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing
import org.zp1ke.platasync.util.formatMoney

data class AccountsScreenState(
    val data: List<UserAccount>,
)

class AccountsScreenViewModel : StateScreenModel<AccountsScreenState>(
    AccountsScreenState(
        data = listOf(),
    ),
) {
    init {
        screenModelScope.launch {
            delay(300)
            mutableState.value = AccountsScreenState(
                data = listOf(
                    UserAccount(
                        id = "1",
                        name = "Savings",
                        icon = AppIcon.ACCOUNT_PIGGY,
                        balance = 15000,
                    ),
                    UserAccount(
                        id = "2",
                        name = "Credit Card",
                        icon = AppIcon.ACCOUNT_CARD,
                        balance = 50000,
                    ),
                )
            )
        }
    }
}

object AccountsScreen : Screen {
    private fun readResolve(): Any = AccountsScreen

    @Composable
    override fun Content() {
        val viewModel = rememberScreenModel { AccountsScreenViewModel() }

        val state by viewModel.state.collectAsState()
        val onAccountAction: (UserAccount) -> Unit = {
            print { "Redirect to edit screen" }
        }

        AccountsListView(
            accounts = state.data,
            onAccountAction = onAccountAction,
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
@Preview
private fun AccountsListView(
    accounts: List<UserAccount> = listOf(
        UserAccount(
            id = "1",
            name = "Savings",
            icon = AppIcon.ACCOUNT_PIGGY,
            balance = 15000,
        ),
        UserAccount(
            id = "2",
            name = "Credit Card",
            icon = AppIcon.ACCOUNT_CARD,
            balance = 50000,
        ),
    ),
    onAccountAction: (account: UserAccount) -> Unit = { _ -> },
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text("TODO accounts", style = MaterialTheme.typography.titleMedium)
                },
            )
        },
    ) { paddingValues ->
        Box(modifier = Modifier.padding(paddingValues)) {
            AccountsList(accounts, onAccountAction)
        }
    }
}

@Composable
private fun AccountsList(
    accounts: List<UserAccount>,
    onAccountAction: (account: UserAccount) -> Unit,
) {
    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(Spacing.small),
    ) {
        items(
            items = accounts,
            key = { it.id },
        ) { account ->
            AccountListItem(
                account = account,
                onClick = {
                    onAccountAction(account)
                },
            )
        }

        item {
            Spacer(Modifier.height(Spacing.medium))
        }
    }
}

@Composable
private fun AccountListItem(
    account: UserAccount,
    onClick: () -> Unit = {},
) {
    Surface(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(horizontal = Spacing.medium)
                .defaultMinSize(minHeight = Spacing.rowMinHeight),
        onClick = onClick,
        shape = RoundedCornerShape(Spacing.small),
        color = MaterialTheme.colorScheme.surfaceVariant,
    ) {
        Row(
            modifier =
                Modifier
                    .padding(
                        horizontal = Spacing.medium,
                        vertical = Spacing.small,
                    ),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(Spacing.large),
        ) {
            Image(
                painterResource(account.icon.resource()), null,
                modifier = Modifier.width(Size.iconSmall),
            )
            Text(
                text = account.name,
                style = MaterialTheme.typography.bodyLarge
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                modifier = Modifier.weight(1f),
            )
            Text(
                text = formatMoney(account.balance),
                style = MaterialTheme.typography.bodyLarge
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
            )
        }
    }
}
