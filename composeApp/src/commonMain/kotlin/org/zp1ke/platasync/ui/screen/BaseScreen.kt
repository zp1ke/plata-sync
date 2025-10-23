package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.model.BaseModel
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.common.LoadingIndicator
import org.zp1ke.platasync.ui.theme.Spacing

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun <T : BaseModel> BaseScreen(
    isLoading: Boolean = false,
    onReload: () -> Unit,
    onAdd: () -> Unit,
    actions: ItemActions<T>,
    titleIcon: (@Composable () -> Unit)? = null,
    titleResource: StringResource,
    subtitle: String? = null,
    refreshResource: StringResource,
    addResource: StringResource,
    topWidgetProvider: TopWidgetProvider? = null,
    list: @Composable (
        enabled: Boolean,
        actions: ItemActions<T>,
    ) -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    ListItem(
                        leadingContent = {
                            if (titleIcon != null) {
                                titleIcon()
                            }
                        },
                        headlineContent = {
                            Text(
                                stringResource(titleResource),
                                style = MaterialTheme.typography.titleMedium,
                            )
                        },
                        supportingContent = {
                            if (subtitle != null) {
                                Text(
                                    subtitle,
                                    style = MaterialTheme.typography.bodyMedium,
                                )
                            }
                        }
                    )
                },
                actions = {
                    if (isLoading) {
                        IconButton(onClick = { }, enabled = false) {
                            LoadingIndicator()
                        }
                    }
                    topWidgetProvider?.action()?.let {
                        topWidgetProvider.action()?.invoke()
                    }
                    IconButton(onClick = { onReload() }, enabled = !isLoading) {
                        Icon(
                            imageVector = Icons.Filled.Refresh,
                            contentDescription = stringResource(refreshResource),
                        )
                    }
                    IconButton(onClick = { onAdd() }, enabled = !isLoading) {
                        Icon(
                            imageVector = Icons.Filled.Add,
                            contentDescription = stringResource(addResource),
                        )
                    }
                },
            )
        },
    ) { paddingValues ->
        Column(
            modifier = Modifier.padding(paddingValues),
            verticalArrangement = Arrangement.spacedBy(Spacing.medium),
        ) {
            topWidgetProvider?.content()?.let {
                Box(
                    modifier = Modifier
                        .clip(MaterialTheme.shapes.small)
                        .background(MaterialTheme.colorScheme.surfaceVariant)
                        .width(IntrinsicSize.Max)
                        .padding(Spacing.medium)
                ) {
                    topWidgetProvider.content()?.invoke()
                }
            }
            list(!isLoading, actions)
        }
    }
}

interface TopWidgetProvider {
    fun action(): (@Composable () -> Unit)?
    fun content(): (@Composable () -> Unit)?
}
