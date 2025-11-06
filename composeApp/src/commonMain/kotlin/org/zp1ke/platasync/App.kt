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
import org.zp1ke.platasync.ui.common.TabItem
import org.zp1ke.platasync.ui.theme.AppTheme

@Composable
@Preview
fun App() {
    KoinApplication(application = {
        modules(appModule())
    }) {
        AppContent()
    }
}

@Composable
private fun AppContent() {
    val allTabs: List<Tab> = getKoin().getAll()
    // Access tab options in composable context and create pairs
    val tabsWithIndex = allTabs.map { tab -> tab to tab.options.index }
    // Sort by index
    val tabs = tabsWithIndex.sortedBy { it.second }.map { it.first }
    val firstTab = tabs.firstOrNull() ?: error("No tabs found")

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
                            tabs.map { TabItem(it) }
                        }
                    }
                )
            }
        }
    }
}
