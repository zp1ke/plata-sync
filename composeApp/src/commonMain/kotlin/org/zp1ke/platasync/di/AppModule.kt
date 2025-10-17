package org.zp1ke.platasync.di

import cafe.adriel.voyager.navigator.tab.Tab
import org.koin.dsl.bind
import org.koin.dsl.module
import org.zp1ke.platasync.data.repository.BaseRepository
import org.zp1ke.platasync.data.repository.DummyAccountsRepository
import org.zp1ke.platasync.data.viewModel.BaseViewModel
import org.zp1ke.platasync.model.UserAccount
import org.zp1ke.platasync.ui.screen.AccountsScreen

val appModule = module {
    // Repositories
    single<BaseRepository<UserAccount>> { DummyAccountsRepository() }

    // ViewModels
    factory { BaseViewModel<UserAccount>(get()) }

    // Screens
    single<AccountsScreen> { AccountsScreen(get()) } bind Tab::class
}
