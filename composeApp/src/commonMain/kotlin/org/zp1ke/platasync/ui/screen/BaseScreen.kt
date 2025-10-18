package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.model.BaseModel
import org.zp1ke.platasync.ui.common.ItemActions
import org.zp1ke.platasync.ui.common.LoadingIndicator

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun <T : BaseModel> BaseScreen(
    isLoading: Boolean = false,
    onReload: () -> Unit,
    onAdd: () -> Unit,
    actions: ItemActions<T>,
    titleResource: StringResource,
    refreshResource: StringResource,
    addResource: StringResource,
    list: @Composable (
        enabled: Boolean,
        actions: ItemActions<T>,
    ) -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        stringResource(titleResource),
                        style = MaterialTheme.typography.titleMedium,
                    )
                },
                actions = {
                    if (isLoading) {
                        IconButton(onClick = { }, enabled = false) {
                            LoadingIndicator()
                        }
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
        Box(modifier = Modifier.padding(paddingValues)) {
            list(!isLoading, actions)
        }
    }
}