package org.zp1ke.platasync.ui.screen

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import androidx.compose.ui.text.font.FontWeight
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabOptions
import org.jetbrains.compose.resources.stringResource
import org.koin.core.annotation.Factory
import org.zp1ke.platasync.ui.theme.Spacing
import platasync.composeapp.generated.resources.*
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.settings_title

val settingsIcon = Icons.Filled.Settings

@Factory
class SettingsScreen() : Tab {

    override val options: TabOptions
        @Composable
        get() {
            val title = stringResource(Res.string.settings_title)
            val icon = rememberVectorPainter(settingsIcon)

            return remember {
                TabOptions(
                    index = 3u,
                    title = title,
                    icon = icon,
                )
            }
        }

    @Composable
    override fun Content() {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(Spacing.medium)
        ) {
            // About Section
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = Spacing.medium)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(Spacing.medium)
                ) {
                    Text(
                        text = stringResource(Res.string.settings_about),
                        style = MaterialTheme.typography.titleLarge,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(bottom = Spacing.small)
                    )

                    Text(
                        text = stringResource(Res.string.settings_app_name),
                        style = MaterialTheme.typography.titleMedium,
                        modifier = Modifier.padding(bottom = Spacing.small)
                    )

                    Text(
                        text = stringResource(Res.string.settings_description),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            // Version Section
            Card(
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(Spacing.medium)
                ) {
                    Text(
                        text = stringResource(Res.string.settings_version),
                        style = MaterialTheme.typography.titleLarge,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(bottom = Spacing.small)
                    )

                    ListItem(
                        headlineContent = {
                            Text(stringResource(Res.string.settings_version))
                        },
                        trailingContent = {
                            Text("1.0")
                        },
                        colors = ListItemDefaults.colors(
                            containerColor = MaterialTheme.colorScheme.surface
                        )
                    )

                    HorizontalDivider()

                    ListItem(
                        headlineContent = {
                            Text(stringResource(Res.string.settings_version_code))
                        },
                        trailingContent = {
                            Text("1")
                        },
                        colors = ListItemDefaults.colors(
                            containerColor = MaterialTheme.colorScheme.surface
                        )
                    )
                }
            }
        }
    }
}
