package org.zp1ke.platasync.di

import org.koin.core.module.dsl.singleOf
import org.koin.dsl.bind
import org.koin.dsl.module
import org.zp1ke.platasync.data.AccountRepository
import org.zp1ke.platasync.data.CategoryRepository
import org.zp1ke.platasync.data.DummyAccountRepository
import org.zp1ke.platasync.data.DummyCategoryRepository

val appModule = module {
    // Repositories
    singleOf(::DummyAccountRepository) bind AccountRepository::class
    singleOf(::DummyCategoryRepository) bind CategoryRepository::class
}
