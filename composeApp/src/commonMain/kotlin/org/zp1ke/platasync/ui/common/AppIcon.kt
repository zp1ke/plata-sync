package org.zp1ke.platasync.ui.common

import org.jetbrains.compose.resources.DrawableResource
import org.jetbrains.compose.resources.StringResource
import platasync.composeapp.generated.resources.*

enum class AppIcon {
    ACCOUNT_BANK {
        override fun resource() = Res.drawable.account_bank
        override fun title() = Res.string.icon_account_bank
    },
    ACCOUNT_CARD {
        override fun resource() = Res.drawable.account_card
        override fun title() = Res.string.icon_account_card
    },
    ACCOUNT_PIGGY {
        override fun resource() = Res.drawable.account_piggy
        override fun title() = Res.string.icon_account_piggy
    },
    CATEGORY_GROCERIES {
        override fun resource() = Res.drawable.category_groceries
        override fun title() = Res.string.icon_category_groceries
    },
    CATEGORY_HOME {
        override fun resource() = Res.drawable.category_home
        override fun title() = Res.string.icon_category_home
    };

    abstract fun resource(): DrawableResource

    abstract fun title(): StringResource
}