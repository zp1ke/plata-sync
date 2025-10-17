package org.zp1ke.platasync.di

import cafe.adriel.voyager.navigator.tab.Tab
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.bind
import org.koin.dsl.binds
import org.koin.dsl.module
import org.zp1ke.platasync.data.AccountRepository
import org.zp1ke.platasync.data.CategoryRepository
import org.zp1ke.platasync.data.DummyAccountRepository
import org.zp1ke.platasync.data.DummyCategoryRepository
import org.zp1ke.platasync.data.viewModel.AccountsScreenViewModel
import org.zp1ke.platasync.ui.screen.AccountsScreen

val appModule = module {
    // Repositories
    singleOf(::DummyAccountRepository) bind AccountRepository::class
    singleOf(::DummyCategoryRepository) bind CategoryRepository::class

    // ViewModels
    singleOf(::AccountsScreenViewModel) bind AccountsScreenViewModel::class

    // Screens
    singleOf(::AccountsScreen) binds arrayOf(Tab::class, AccountsScreen::class)
}
