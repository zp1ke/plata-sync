package org.zp1ke.platasync.data

/**
 * Simple dependency injection container for repositories.
 * In a production app, you might use Koin, Kodein, or another DI framework.
 */
object RepositoryProvider {
    private val accountRepository: AccountRepository by lazy {
        DummyAccountRepository()
    }

    private val categoryRepository: CategoryRepository by lazy {
        DummyCategoryRepository()
    }

    fun provideAccountRepository(): AccountRepository = accountRepository

    fun provideCategoryRepository(): CategoryRepository = categoryRepository
}

