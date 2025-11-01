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

interface TransactionsRepository : BaseRepository<UserTransaction> {
    suspend fun getFull(
        sortKey: String = DomainModel.COLUMN_CREATED_AT,
        sortOrder: SortOrder = SortOrder.DESC,
        limit: Int,
        offset: Int,
    ): List<UserFullTransaction>
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

    override suspend fun getBalanceStats(): BalanceStats {
        val income = transactionDao.sumAmount(TransactionType.INCOME) ?: 0
        val expense = transactionDao.sumAmount(TransactionType.EXPENSE) ?: 0
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
        offset: Int
    ): List<UserFullTransaction> = transactionDao.getFull(sortKey, sortOrder, limit, offset)

    companion object {
        const val KEY = "transactionsRepository"
    }
}