package org.zp1ke.platasync.ui.common

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing

enum class ViewMode {
    LIST,
    GRID
}

@Composable
fun <T : DomainModel> BaseList(
    items: List<T>,
    actions: ItemActions<T>,
    enabled: Boolean = true,
    viewMode: ViewMode = ViewMode.GRID,
    emptyStringResource: StringResource,
    itemContent: @Composable (item: T, viewMode: ViewMode, actions: ItemActions<T>, enabled: Boolean) -> Unit,
) {
    Box(modifier = Modifier.fillMaxSize()) {
        when (viewMode) {
            ViewMode.LIST -> {
                LazyColumn(
                    verticalArrangement = Arrangement.spacedBy(Spacing.small),
                    modifier = Modifier.padding(horizontal = Spacing.small),
                ) {
                    items(
                        items = items,
                        key = { it.id() },
                    ) { item ->
                        itemContent(item, viewMode, actions, enabled)
                    }
                }
            }

            ViewMode.GRID -> {
                LazyVerticalGrid(
                    columns = GridCells.Adaptive(minSize = 300.dp),
                    verticalArrangement = Arrangement.spacedBy(Spacing.small),
                    horizontalArrangement = Arrangement.spacedBy(Spacing.small),
                    modifier = Modifier.padding(horizontal = Spacing.small),
                ) {
                    items(
                        items = items,
                        key = { it.id() },
                    ) { item ->
                        itemContent(item, viewMode, actions, enabled)
                    }
                }
            }
        }

        if (items.isEmpty() && enabled) {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = stringResource(emptyStringResource),
                    style = MaterialTheme.typography.titleLarge
                        .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = Spacing.medium),
                )
            }
        }

        if (items.isEmpty() && !enabled) {
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                LoadingIndicator(size = Size.iconLarge, strokeWidth = Size.strokeMedium)
            }
        }
    }
}

