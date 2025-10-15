package org.zp1ke.platasync

import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Window
import androidx.compose.ui.window.application
import androidx.compose.ui.window.rememberWindowState

fun main() = application {
    val state = rememberWindowState(
        size = DpSize(650.dp, 900.dp),
    )
    Window(
        onCloseRequest = ::exitApplication,
        title = "PlataSync",
        state = state,
        resizable = false,
    ) {
        App()
    }
}