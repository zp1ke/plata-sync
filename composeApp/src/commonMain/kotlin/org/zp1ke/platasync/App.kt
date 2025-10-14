package org.zp1ke.platasync

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.safeContentPadding
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import org.jetbrains.compose.resources.painterResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.ui.theme.AppTheme

import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.compose_multiplatform

@Composable
@Preview
fun App() {
    AppTheme {
        var showContent by remember { mutableStateOf(false) }
        val colorScheme = MaterialTheme.colorScheme
        Column(
            modifier = Modifier
                .background(colorScheme.background)
                .safeContentPadding()
                .fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            Button(
                colors = ButtonDefaults.outlinedButtonColors(containerColor = colorScheme.primaryContainer),
                onClick = { showContent = !showContent }) {
                Text("Click me!", color = colorScheme.onPrimaryContainer)
            }
            AnimatedVisibility(showContent) {
                val greeting = remember { Greeting().greet() }
                Column(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                ) {
                    Image(painterResource(Res.drawable.compose_multiplatform), null)
                    Text(
                        text = "Compose: $greeting",
                        color = colorScheme.onBackground
                    )
                }
            }
        }
    }
}