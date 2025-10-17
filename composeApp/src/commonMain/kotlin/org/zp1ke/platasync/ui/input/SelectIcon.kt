package org.zp1ke.platasync.ui.form

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import org.jetbrains.compose.resources.stringResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.zp1ke.platasync.ui.common.AppIcon
import org.zp1ke.platasync.ui.common.ImageIcon
import org.zp1ke.platasync.ui.theme.Size
import org.zp1ke.platasync.ui.theme.Spacing

@Composable
@Preview
fun SelectIcon(
    value: AppIcon = AppIcon.ACCOUNT_BANK,
    options: List<AppIcon> = AppIcon.entries,
    onChanged: (AppIcon) -> Unit = { _ -> },
) {
    var expanded by remember { mutableStateOf(false) }
    var selected by remember { mutableStateOf(value) }

    Column(
        modifier = Modifier.padding(Spacing.medium),
        verticalArrangement = Arrangement.spacedBy(Spacing.small),
    ) {
        IconButton(
            onClick = { expanded = !expanded }
        ) {
            ImageIcon(selected, width = Size.iconLarge)
        }

        DropdownMenu(
            expanded = expanded,
            onDismissRequest = { expanded = false }
        ) {
            Column(
                modifier = Modifier.padding(Spacing.medium),
                verticalArrangement = Arrangement.spacedBy(Spacing.small),
            ) {
                options.forEach { option ->
                    DropdownMenuItem(
                        modifier = Modifier.padding(vertical = Spacing.small),
                        leadingIcon = { ImageIcon(option, width = Size.iconLarge) },
                        text = {
                            Text(
                                stringResource(option.title()),
                                fontWeight = if (option == selected) FontWeight.Bold else FontWeight.Normal,
                            )
                        },
                        onClick = {
                            selected = option
                            expanded = false
                            if (option != value) {
                                onChanged(option)
                            }
                        }
                    )
                }
            }
        }
    }
}
