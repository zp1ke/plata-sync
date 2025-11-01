package org.zp1ke.platasync.ui.common

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.unit.Dp
import org.jetbrains.compose.resources.painterResource
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing

@Composable
fun ImageIcon(
    icon: AppIcon,
    modifier: Modifier = Modifier,
    width: Dp = Size.iconMedium,
    shape: Shape = RoundedCornerShape(Size.iconBorderSmall),
) {
    Card(
        modifier = modifier.width(width).padding(Spacing.small),
        shape = shape,
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        border = CardDefaults.outlinedCardBorder()
    ) {
        Image(
            painterResource(icon.icon()), null,
            modifier = Modifier.padding(Spacing.small),
        )
    }
}