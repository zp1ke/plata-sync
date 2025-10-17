package org.zp1ke.platasync.ui.common

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.ui.theme.Size

@Composable
@Preview
fun LoadingIndicator(
    paddingValues: PaddingValues = PaddingValues(0.dp),
) {
    CircularProgressIndicator(
        modifier = Modifier
            .padding(paddingValues)
            .size(Size.iconSmall),
        strokeWidth = 2.dp,
    )
}