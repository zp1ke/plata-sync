package org.zp1ke.platasync.ui.common

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DeleteForever
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.style.TextAlign
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing

@Composable
fun <T : DomainModel> BaseList(
    items: List<T>,
    actions: ItemActions<T>,
    enabled: Boolean = true,
    emptyStringResource: StringResource,
    editStringResource: StringResource,
    deleteStringResource: StringResource,
    itemHeadlineContent: (T) -> (@Composable () -> Unit),
    itemSupportingContent: ((T) -> (@Composable () -> Unit))? = null,
    itemLeadingContent: (T) -> (@Composable () -> Unit),
) {
    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(Spacing.small),
        modifier = Modifier.padding(horizontal = Spacing.small),
    ) {
        items(
            items = items,
            key = { it.id() },
        ) { item ->
            BaseListItem(
                onView = { actions.onView(item) },
                onEdit = { actions.onEdit(item) },
                onDelete = { actions.onDelete(item) },
                enabled = enabled,
                headlineContent = itemHeadlineContent(item),
                supportingContent = itemSupportingContent?.let { it(item) } ?: {},
                leadingContent = itemLeadingContent(item),
                editStringResource = editStringResource,
                deleteStringResource = deleteStringResource,
            )
        }

        if (items.isEmpty()) {
            item {
                Spacer(modifier = Modifier.height(Size.iconLarge))
            }
        }

        if (items.isEmpty() && enabled) {
            item {
                Text(
                    text = stringResource(emptyStringResource),
                    style = MaterialTheme.typography.titleLarge
                        .copy(color = MaterialTheme.colorScheme.onSurfaceVariant),
                    textAlign = TextAlign.Center,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = Spacing.medium),
                )
            }
        }

        if (items.isEmpty() && !enabled) {
            item {
                Box(
                    modifier = Modifier.fillMaxWidth(),
                    contentAlignment = Alignment.Center
                ) {
                    LoadingIndicator(size = Size.iconLarge, strokeWidth = Size.strokeMedium)
                }
            }
        }
    }
}

@Composable
private fun BaseListItem(
    onView: () -> Unit,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
    enabled: Boolean = true,
    headlineContent: @Composable () -> Unit,
    supportingContent: @Composable () -> Unit,
    leadingContent: @Composable () -> Unit,
    editStringResource: StringResource,
    deleteStringResource: StringResource,
) {
    ListItem(
        modifier = Modifier
            .clip(MaterialTheme.shapes.small)
            .clickable(enabled = enabled, onClick = onView)
            .padding(horizontal = Spacing.small),
        colors = ListItemDefaults.colors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        headlineContent = headlineContent,
        supportingContent = supportingContent,
        leadingContent = leadingContent,
        trailingContent = {
            Row {
                IconButton(onClick = { onEdit() }, enabled = enabled) {
                    Icon(
                        imageVector = Icons.Filled.Edit,
                        contentDescription = stringResource(editStringResource),
                        modifier = Modifier.width(Size.iconSmall),
                    )
                }
                IconButton(onClick = { onDelete() }, enabled = enabled) {
                    Icon(
                        imageVector = Icons.Filled.DeleteForever,
                        contentDescription = stringResource(deleteStringResource),
                        modifier = Modifier.width(Size.iconSmall),
                    )
                }
            }
        },
    )
}