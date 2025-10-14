package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
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
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.UserCategory
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing

data class CategoriesScreenState(
    val data: List<UserCategory>,
)

class CategoriesScreenViewModel : StateScreenModel<CategoriesScreenState>(
    CategoriesScreenState(
        data = listOf(),
    ),
) {
    init {
        screenModelScope.launch {
            delay(300)
            mutableState.value = CategoriesScreenState(
                data = listOf(
                    UserCategory(
                        id = "1",
                        name = "Technology",
                    ),
                    UserCategory(
                        id = "2",
                        name = "Home",
                    ),
                    UserCategory(
                        id = "3",
                        name = "Groceries",
                    ),
                )
            )
        }
    }
}

object CategoriesScreen : Screen {
    private fun readResolve(): Any = CategoriesScreen

    @Composable
    override fun Content() {
        val viewModel = rememberScreenModel { CategoriesScreenViewModel() }

        val state by viewModel.state.collectAsState()
        val onCategoryAction: (UserCategory) -> Unit = {
            print { "Redirect to edit screen" }
        }

        CategoriesListView(
            categories = state.data,
            onCategoryAction = onCategoryAction,
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
@Preview
private fun CategoriesListView(
    categories: List<UserCategory> = listOf(
        UserCategory(
            id = "1",
            name = "Technology",
        ),
        UserCategory(
            id = "2",
            name = "Home",
        ),
        UserCategory(
            id = "3",
            name = "Groceries",
        ),
    ),
    onCategoryAction: (category: UserCategory) -> Unit = { _ -> },
) {
    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = {
                    Text("TODO categories", style = MaterialTheme.typography.titleMedium)
                },
            )
        },
        bottomBar = {
            BottomAppBar(
                contentPadding = PaddingValues(horizontal = Spacing.large),
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween,
                ) {
                    Column {
                        Text(
                            "Average expenses",
                            style = MaterialTheme.typography.bodyLarge,
                        )
                        Text(
                            "Per month".uppercase(),
                            style = MaterialTheme.typography.bodyMedium,
                        )
                    }
                    Text(
                        "state.avgExpenses",
                        style = MaterialTheme.typography.labelLarge,
                    )
                }
            }
        },
    ) { paddingValues ->
        Box(modifier = Modifier.padding(paddingValues)) {
            CategoriesList(categories, onCategoryAction)
        }
    }
}

@Composable
private fun CategoriesList(
    categories: List<UserCategory>,
    onCategoryAction: (category: UserCategory) -> Unit,
) {
    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(Spacing.small),
    ) {
        items(
            items = categories,
            key = { it.id },
        ) { category ->
            CategoryListItem(
                category = category,
                onClick = {
                    onCategoryAction(category)
                },
            )
        }

        item {
            Spacer(Modifier.height(Spacing.medium))
        }
    }
}

@Composable
private fun CategoryListItem(
    category: UserCategory,
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
            Text(
                text = "ICON",
                fontSize = Size.iconMedium,
                modifier = Modifier.defaultMinSize(minWidth = Size.iconMinWidth),
            )
            Text(
                text = category.name,
                style = MaterialTheme.typography.bodyLarge.copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                modifier = Modifier.weight(1f),
            )
        }
    }
}
