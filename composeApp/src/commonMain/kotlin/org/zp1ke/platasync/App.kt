package org.zp1ke.platasync

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeContentPadding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import cafe.adriel.voyager.navigator.Navigator
import cafe.adriel.voyager.transitions.SlideTransition
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.ui.screen.AccountsScreen
import org.zp1ke.platasync.ui.screen.CategoriesScreen
import org.zp1ke.platasync.ui.theme.AppTheme

@Composable
@Preview
fun App() {
    AppTheme {
        Scaffold { innerPadding ->
            Surface(
                modifier = Modifier
                    .background(MaterialTheme.colorScheme.background)
                    .safeContentPadding()
                    .padding(innerPadding)
                    .fillMaxSize(),
                color = MaterialTheme.colorScheme.background,
            ) {
                Navigator(AccountsScreen) { navigator ->
                    SlideTransition(navigator)
                }
            }
        }
    }
}
