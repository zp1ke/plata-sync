package org.zp1ke.platasync.model

import org.jetbrains.compose.resources.DrawableResource
import platasync.composeapp.generated.resources.Res
import platasync.composeapp.generated.resources.account_bank
import platasync.composeapp.generated.resources.account_card
import platasync.composeapp.generated.resources.account_piggy
import platasync.composeapp.generated.resources.category_groceries
import platasync.composeapp.generated.resources.category_home

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
    CATEGORY_GROCERIES {
        override fun resource() = Res.drawable.category_groceries
    },
    CATEGORY_HOME {
        override fun resource() = Res.drawable.category_home
    };

    abstract fun resource(): DrawableResource
}
