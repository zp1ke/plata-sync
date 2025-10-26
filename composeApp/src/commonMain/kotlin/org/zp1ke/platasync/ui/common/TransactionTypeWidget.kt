package org.zp1ke.platasync.ui.common

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.TextStyle
import org.jetbrains.compose.resources.stringResource
import org.zp1ke.platasync.model.TransactionType
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing

@Composable
fun TransactionTypeWidget(
    type: TransactionType,
    modifier: Modifier = Modifier,
    textStyle: TextStyle = MaterialTheme.typography.bodyMedium,
) {
    val isDarkMode = isSystemInDarkTheme()
    Row(
        horizontalArrangement = Arrangement.spacedBy(Spacing.small),
        verticalAlignment = Alignment.CenterVertically,
        modifier = modifier
    ) {
        Icon(
            imageVector = type.icon(),
            contentDescription = null,
            tint = type.color(isDarkMode),
            modifier = Modifier.size(Size.iconSmall)
        )
        Text(
            text = stringResource(type.title()),
            style = textStyle,
            color = type.color(isDarkMode)
        )
    }
}
