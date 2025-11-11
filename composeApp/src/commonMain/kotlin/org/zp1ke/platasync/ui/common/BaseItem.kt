package org.zp1ke.platasync.ui.common

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DeleteForever
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing

@Composable
fun BaseItem(
    viewMode: ViewMode,
    enabled: Boolean,
    onView: () -> Unit,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
    editStringResource: StringResource,
    deleteStringResource: StringResource,
    leadingContent: @Composable () -> Unit,
    headlineContent: @Composable () -> Unit,
    supportingContent: @Composable () -> Unit,
) {
    when (viewMode) {
        ViewMode.LIST -> {
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
                        IconButton(onClick = onEdit, enabled = enabled) {
                            Icon(
                                imageVector = Icons.Filled.Edit,
                                contentDescription = stringResource(editStringResource),
                                modifier = Modifier.width(Size.iconSmall),
                            )
                        }
                        IconButton(onClick = onDelete, enabled = enabled) {
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

        ViewMode.GRID -> {
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable(enabled = enabled, onClick = onView),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceVariant
                ),
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(Spacing.medium),
                    verticalArrangement = Arrangement.spacedBy(Spacing.small)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(modifier = Modifier.padding(end = Spacing.small)) {
                            leadingContent()
                        }
                        Row {
                            IconButton(onClick = onEdit, enabled = enabled) {
                                Icon(
                                    imageVector = Icons.Filled.Edit,
                                    contentDescription = stringResource(editStringResource),
                                    modifier = Modifier.width(Size.iconSmall),
                                )
                            }
                            IconButton(onClick = onDelete, enabled = enabled) {
                                Icon(
                                    imageVector = Icons.Filled.DeleteForever,
                                    contentDescription = stringResource(deleteStringResource),
                                    modifier = Modifier.width(Size.iconSmall),
                                )
                            }
                        }
                    }
                    Column(
                        modifier = Modifier.fillMaxWidth(),
                        verticalArrangement = Arrangement.spacedBy(Spacing.small)
                    ) {
                        headlineContent()
                        supportingContent()
                    }
                }
            }
        }
    }
}

