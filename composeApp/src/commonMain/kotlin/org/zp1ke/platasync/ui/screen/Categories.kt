package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Category
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import cafe.adriel.voyager.core.model.StateScreenModel
import cafe.adriel.voyager.core.model.rememberScreenModel
import cafe.adriel.voyager.core.model.screenModelScope
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.data.CategoryRepository
import org.zp1ke.platasync.data.RepositoryProvider
import org.zp1ke.platasync.model.AppIcon
import org.zp1ke.platasync.model.UserCategory
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.category_list

data class CategoriesScreenState(
    val data: List<UserCategory>,
)

class CategoriesScreenViewModel(
    private val repository: CategoryRepository = RepositoryProvider.provideCategoryRepository()
) : StateScreenModel<CategoriesScreenState>(
    CategoriesScreenState(
        data = listOf(),
    ),
) {
    init {
        loadCategories()
    }

    private fun loadCategories() {
        screenModelScope.launch {
            val categories = repository.getAllCategories()
            mutableState.value = CategoriesScreenState(
                data = categories
            )
        }
    }

    fun addCategory(category: UserCategory) {
        screenModelScope.launch {
            val index = mutableState.value.data.indexOfFirst { it.id == category.id }
            if (index >= 0) {
                // Update existing
                repository.updateCategory(category)
            } else {
                repository.addCategory(category)
            }
            loadCategories()
        }
    }

    fun removeCategory(category: UserCategory) {
        screenModelScope.launch {
            repository.deleteCategory(category.id)
            loadCategories()
        }
    }
}

object CategoriesScreen : Tab {

    override val options: TabOptions
        @Composable
        get() {
            val title = stringResource(Res.string.category_list)
            val icon = rememberVectorPainter(Icons.Filled.Category)

            return remember {
                TabOptions(
                    index = 1u,
                    title = title,
                    icon = icon,
                )
            }
        }

    @Composable
    override fun Content() {
        val viewModel = rememberScreenModel { CategoriesScreenViewModel() }
        val state by viewModel.state.collectAsState()

        CategoriesListView(categories = state.data)
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
            CategoriesList(categories)
        }
    }
}

@Composable
private fun CategoriesList(
    categories: List<UserCategory>,
) {
    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(Spacing.small),
        modifier = Modifier.padding(horizontal = Spacing.small),
    ) {
        items(
            items = categories,
            key = { it.id },
        ) { category ->
            CategoryListItem(category = category)
        }

        item {
            Spacer(Modifier.height(Spacing.medium))
        }
    }
}

@Composable
private fun CategoryListItem(
    category: UserCategory,
) {
    ListItem(
        modifier = Modifier
            .clip(MaterialTheme.shapes.small)
            .padding(horizontal = Spacing.small),
        colors = ListItemDefaults.colors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        headlineContent = {
            Text(
                text = category.name,
                style = MaterialTheme.typography.titleMedium
                    .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
            )
        },
        leadingContent = {
            ImageIcon(category.icon)
        }
    )
}
