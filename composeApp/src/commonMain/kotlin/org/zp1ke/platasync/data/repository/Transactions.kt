package org.zp1ke.platasync.data.repository

import org.koin.core.annotation.Named
import org.koin.core.annotation.Single
import org.zp1ke.platasync.data.dao.UserTransactionDao
import org.zp1ke.platasync.data.model.SortOrder
import org.zp1ke.platasync.data.model.UserFullTransaction
import org.zp1ke.platasync.data.room.AppDatabase
import org.zp1ke.platasync.domain.DomainModel
import org.zp1ke.platasync.domain.UserTransaction
import org.zp1ke.platasync.model.BalanceStats
import org.zp1ke.platasync.model.TransactionType
import java.time.OffsetDateTime

interface TransactionsRepository : BaseRepository<UserTransaction> {
    /**
     * Get full transactions with related data (e.g., account info) between the given date range.
     * The date range is inclusive.
     **/
    suspend fun getFull(
        sortKey: String = DomainModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
        limit: Int,
        offset: Int,
        from: OffsetDateTime,
        to: OffsetDateTime,
        accountId: String? = null,
        categoryId: String? = null,
    ): List<UserFullTransaction>

    /**
     * Get balance stats (total income and expense) between the given date range.
     * The date range is inclusive.
     **/
    suspend fun getBalanceStats(
        from: OffsetDateTime,
        to: OffsetDateTime,
        accountId: String? = null,
        categoryId: String? = null,
    ): BalanceStats
}

@Single
@Named(DaoTransactionsRepository.KEY)
class DaoTransactionsRepository(
    database: AppDatabase,
) : TransactionsRepository {
    private val transactionDao: UserTransactionDao = database.getTransactionDao()

    override suspend fun getAllItems(
        filters: Map<String, String>,
        sortKey: String,
        sortOrder: SortOrder,
    ): List<UserTransaction> {
        return transactionDao.getAll(sortKey, sortOrder)
    }

    override suspend fun getBalanceStats(
        from: OffsetDateTime,
        to: OffsetDateTime,
        accountId: String?,
        categoryId: String?,
    ): BalanceStats {
        val income = transactionDao.sumAmount(TransactionType.INCOME, from, to, accountId, categoryId) ?: 0
        val expense = transactionDao.sumAmount(TransactionType.EXPENSE, from, to, accountId, categoryId) ?: 0
        return BalanceStats(
            income = income,
            expense = expense,
        )
    }

    override suspend fun getItemById(id: String): UserTransaction? = transactionDao.getById(id)

    override suspend fun saveItem(item: UserTransaction) = transactionDao.save(item)

    override suspend fun deleteItem(id: String) = transactionDao.deleteById(id)

    override suspend fun getFull(
        sortKey: String,
        sortOrder: SortOrder,
        limit: Int,
        offset: Int,
        from: OffsetDateTime,
        to: OffsetDateTime,
        accountId: String?,
        categoryId: String?,
    ): List<UserFullTransaction> =
        transactionDao.getFull(sortKey, sortOrder, limit, offset, from, to, accountId, categoryId)

    companion object {
        const val KEY = "transactionsRepository"
    }
}