package org.zp1ke.platasync.ui.input

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun <T> ItemSelector(
    label: String,
    selectedItem: T?,
    items: List<T>,
    onSearch: (String) -> Unit,
    onLoadMore: () -> Unit,
    hasMore: Boolean,
    isLoading: Boolean,
    itemContent: @Composable (T) -> Unit,
    itemKey: (T) -> String,
    itemText: (T) -> String,
    onItemSelected: (T) -> Unit,
    modifier: Modifier = Modifier,
) {
    var showDialog by remember { mutableStateOf(false) }
    var searchQuery by remember { mutableStateOf("") }
    val listState = rememberLazyListState()
    val coroutineScope = rememberCoroutineScope()

    // Detect when user scrolls near the end
    LaunchedEffect(listState.canScrollForward, listState.isScrollInProgress) {
        if (!listState.canScrollForward && !listState.isScrollInProgress && hasMore && !isLoading) {
            onLoadMore()
        }
    }

    // Main selector button
    Box(
        modifier = modifier
            .fillMaxWidth()
            .clickable { showDialog = true }
    ) {
        OutlinedTextField(
            value = if (selectedItem != null) itemText(selectedItem) else "",
            onValueChange = {},
            label = { Text(label) },
            readOnly = true,
            enabled = false,
            trailingIcon = {
                Icon(
                    imageVector = Icons.Default.ArrowDropDown,
                    contentDescription = null
                )
            },
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(
                disabledTextColor = MaterialTheme.colorScheme.onSurface,
                disabledBorderColor = MaterialTheme.colorScheme.outline,
                disabledLeadingIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                disabledTrailingIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                disabledLabelColor = MaterialTheme.colorScheme.onSurfaceVariant,
                disabledPlaceholderColor = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        )
    }

    // Dialog with search and list
    if (showDialog) {
        Dialog(
            onDismissRequest = { showDialog = false },
            properties = DialogProperties(usePlatformDefaultWidth = false)
        ) {
            Surface(
                shape = MaterialTheme.shapes.medium,
                color = MaterialTheme.colorScheme.background,
                modifier = Modifier
                    .fillMaxWidth()
                    .fillMaxHeight(0.8f)
                    .padding(horizontal = Spacing.medium)
            ) {
                Column(
                    modifier = Modifier.padding(Spacing.medium),
                    verticalArrangement = Arrangement.spacedBy(Spacing.small)
                ) {
                    // Header
                    Text(
                        text = label,
                        style = MaterialTheme.typography.titleLarge,
                        modifier = Modifier.padding(bottom = Spacing.small)
                    )

                    // Search field
                    OutlinedTextField(
                        value = searchQuery,
                        onValueChange = {
                            searchQuery = it
                            onSearch(it)
                        },
                        label = { Text(stringResource(Res.string.action_search)) },
                        leadingIcon = {
                            Icon(
                                imageVector = Icons.Default.Search,
                                contentDescription = null
                            )
                        },
                        trailingIcon = {
                            if (searchQuery.isNotEmpty()) {
                                TextButton(onClick = {
                                    searchQuery = ""
                                    onSearch("")
                                }) {
                                    Text(stringResource(Res.string.action_clear))
                                }
                            }
                        },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true
                    )

                    HorizontalDivider()

                    // Items list
                    Box(modifier = Modifier.weight(1f)) {
                        if (items.isEmpty() && !isLoading) {
                            Text(
                                text = stringResource(Res.string.no_items_found),
                                style = MaterialTheme.typography.bodyLarge,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(Spacing.medium)
                                    .align(Alignment.Center)
                            )
                        } else {
                            LazyColumn(
                                state = listState,
                                modifier = Modifier.fillMaxSize(),
                                verticalArrangement = Arrangement.spacedBy(Spacing.small)
                            ) {
                                items(
                                    items = items,
                                    key = { itemKey(it) }
                                ) { item ->
                                    Card(
                                        modifier = Modifier
                                            .fillMaxWidth()
                                            .clickable {
                                                onItemSelected(item)
                                                showDialog = false
                                                searchQuery = ""
                                            },
                                        colors = CardDefaults.cardColors(
                                            containerColor = if (selectedItem != null && itemKey(
                                                    selectedItem
                                                ) == itemKey(item)
                                            ) {
                                                MaterialTheme.colorScheme.primaryContainer
                                            } else {
                                                MaterialTheme.colorScheme.surface
                                            }
                                        )
                                    ) {
                                        Box(
                                            modifier = Modifier
                                                .fillMaxWidth()
                                                .padding(Spacing.medium)
                                        ) {
                                            itemContent(item)
                                        }
                                    }
                                }

                                // Loading indicator for pagination
                                if (isLoading) {
                                    item {
                                        Box(
                                            modifier = Modifier
                                                .fillMaxWidth()
                                                .padding(Spacing.medium),
                                            contentAlignment = Alignment.Center
                                        ) {
                                            CircularProgressIndicator()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    HorizontalDivider()

                    // Close button
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End
                    ) {
                        TextButton(onClick = {
                            showDialog = false
                            searchQuery = ""
                        }) {
                            Text(stringResource(Res.string.action_cancel))
                        }
                    }
                }
            }
        }
    }
}

