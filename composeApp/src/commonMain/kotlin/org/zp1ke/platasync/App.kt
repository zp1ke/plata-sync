package org.zp1ke.platasync

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import cafe.adriel.voyager.navigator.tab.CurrentTab
import cafe.adriel.voyager.navigator.tab.TabNavigator
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.ui.navigation.TabItem
import org.zp1ke.platasync.ui.screen.AccountsScreen
import org.zp1ke.platasync.ui.screen.CategoriesScreen
import org.zp1ke.platasync.ui.theme.AppTheme

@Composable
@Preview
fun App() {
    AppTheme {
        Surface(
            modifier = Modifier
                .background(MaterialTheme.colorScheme.background)
                .fillMaxSize(),
            color = MaterialTheme.colorScheme.background,
        ) {
            TabNavigator(AccountsScreen) {
                Scaffold(
                    content = { paddingValues ->
                        CurrentTab()
                    },
                    bottomBar = {
                        NavigationBar(
                            containerColor = MaterialTheme.colorScheme.background,
                        ) {
                            TabItem(AccountsScreen)
                            TabItem(CategoriesScreen)
                        }
                    }
                )
            }
        }
    }
}
