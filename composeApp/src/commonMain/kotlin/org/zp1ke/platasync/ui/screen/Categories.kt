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
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.rememberScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.painterResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.model.AppIcon
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
                        name = "Home",
                        icon = AppIcon.CATEGORY_HOME,
                    ),
                    UserCategory(
                        id = "2",
                        name = "Groceries",
                        icon = AppIcon.CATEGORY_GROCERIES,
                    ),
                )
            )
        }
    }
}

object CategoriesScreen : Tab {

    override val options: TabOptions
        @Composable
        get() {
            return remember {
                TabOptions(
                    index = 1u,
                    title = "CAT TODO",
                )
            }
        }

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
            name = "Home",
            icon = AppIcon.CATEGORY_HOME,
        ),
        UserCategory(
            id = "2",
            name = "Groceries",
            icon = AppIcon.CATEGORY_GROCERIES,
        ),
    ),
    onCategoryAction: (category: UserCategory) -> Unit = { _ -> },
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text("TODO categories", style = MaterialTheme.typography.titleMedium)
                },
            )
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
            Image(
                painterResource(category.icon.resource()), null,
                modifier = Modifier.width(Size.iconSmall),
            )
            Text(
                text = category.name,
                style = MaterialTheme.typography.bodyLarge.copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                modifier = Modifier.weight(1f),
            )
        }
    }
}
