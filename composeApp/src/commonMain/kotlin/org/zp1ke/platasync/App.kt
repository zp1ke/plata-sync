package org.zp1ke.platasync

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.LayoutDirection
import cafe.adriel.voyager.navigator.tab.CurrentTab
import cafe.adriel.voyager.navigator.tab.Tab
import cafe.adriel.voyager.navigator.tab.TabNavigator
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.koin.compose.KoinApplication
import org.koin.compose.getKoin
import org.koin.ksp.generated.module
import org.zp1ke.platasync.ui.common.TabItem
import org.zp1ke.platasync.ui.theme.AppTheme

@Composable
@Preview
fun App() {
    KoinApplication(application = {
        modules(AppModule().module)
    }) {
        val tabs: List<Tab> = getKoin().getAll()
        // Determine the first tab to show based on the lowest index and title
        val firstTab = tabs.minByOrNull { tab -> tab.options.index }?.let { minIndexTab ->
            tabs.filter { it.options.index == minIndexTab.options.index }
                .minByOrNull { it.options.title }
        } ?: tabs.first()

        AppTheme {
            Surface(
                modifier = Modifier
                    .background(MaterialTheme.colorScheme.background)
                    .fillMaxSize(),
                color = MaterialTheme.colorScheme.background,
            ) {
                TabNavigator(firstTab) {
                    Scaffold(
                        content = { paddingValues ->
                            Column(
                                modifier = Modifier
                                    .fillMaxSize()
                                    .padding(
                                        start = paddingValues.calculateLeftPadding(LayoutDirection.Ltr),
                                        end = paddingValues.calculateRightPadding(LayoutDirection.Ltr),
                                    )
                            ) {
                                CurrentTab()
                            }
                        },
                        bottomBar = {
                            NavigationBar(
                                containerColor = MaterialTheme.colorScheme.background,
                            ) {
                                tabs.map { tab -> TabItem(tab) }
                            }
                        }
                    )
                }
            }
        }
    }
}
