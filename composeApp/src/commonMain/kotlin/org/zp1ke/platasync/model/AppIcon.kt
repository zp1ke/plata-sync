package org.zp1ke.platasync.model

import org.jetbrains.compose.resources.DrawableResource
import platasync.composeapp.generated.resources.*

enum class AppIcon {
    ACCOUNT_BANK {
        override fun resource() = Res.drawable.account_bank
    },
    ACCOUNT_CARD {
        override fun resource() = Res.drawable.account_card
    },
    ACCOUNT_PIGGY {
        override fun resource() = Res.drawable.account_piggy
    },
    ACTION_DELETE {
        override fun resource() = Res.drawable.action_delete
    },
    CATEGORY_GROCERIES {
        override fun resource() = Res.drawable.category_groceries
    },
    CATEGORY_HOME {
        override fun resource() = Res.drawable.category_home
    };

    abstract fun resource(): DrawableResource
}
