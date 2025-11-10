package org.zp1ke.platasync.ui.common

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ViewList
import androidx.compose.material.icons.filled.GridView
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.runtime.Composable
import org.jetbrains.compose.resources.stringResource
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.view_mode_grid
import platasync.composeapp.generated.resources.view_mode_list

@Composable
fun ViewModeToggle(
    viewMode: ViewMode,
    onViewModeChange: (ViewMode) -> Unit,
    enabled: Boolean = true,
) {
    IconButton(
        onClick = {
            onViewModeChange(
                when (viewMode) {
                    ViewMode.LIST -> ViewMode.GRID
                    ViewMode.GRID -> ViewMode.LIST
                }
            )
        },
        enabled = enabled
    ) {
        Icon(
            imageVector = when (viewMode) {
                ViewMode.LIST -> Icons.Filled.GridView
                ViewMode.GRID -> Icons.AutoMirrored.Filled.ViewList
            },
            contentDescription = stringResource(
                when (viewMode) {
                    ViewMode.LIST -> Res.string.view_mode_grid
                    ViewMode.GRID -> Res.string.view_mode_list
                }
            ),
        )
    }
}
