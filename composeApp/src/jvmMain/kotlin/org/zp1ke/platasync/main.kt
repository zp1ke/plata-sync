package org.zp1ke.platasync

import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Window
import androidx.compose.ui.window.WindowPosition
import androidx.compose.ui.window.application
import androidx.compose.ui.window.rememberWindowState

fun main() = application {
    val state = rememberWindowState(
        size = DpSize(600.dp, 800.dp),
        position = WindowPosition(400.dp, 400.dp)
    )
    Window(
        onCloseRequest = ::exitApplication,
        title = "PlataSync",
        state = state,
    ) {
        App()
    }
}