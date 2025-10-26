package org.zp1ke.platasync.ui.common

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.unit.Dp
import org.jetbrains.compose.resources.painterResource
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing

@Composable
fun ImageIcon(
    icon: AppIcon,
    width: Dp = Size.iconMedium,
    shape: Shape = RoundedCornerShape(Size.iconBorderSmall),
) {
    Image(
        painterResource(icon.icon()), null,
        modifier = Modifier
            .width(width)
            .clip(shape)
            .background(MaterialTheme.colorScheme.background)
            .padding(Spacing.small),
    )
}