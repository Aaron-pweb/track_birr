package com.example.track_birr.data.repository

import com.example.track_birr.data.local.Expense
import com.example.track_birr.data.local.ExpenseDao
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class ExpenseRepositoryImpl @Inject constructor(
    private val dao: ExpenseDao
) : ExpenseRepository {

    override fun getAllExpenses(): Flow<List<Expense>> {
        return dao.getAllExpenses()
    }

    override suspend fun insertExpense(expense: Expense) {
        dao.insertExpense(expense)
    }

    override suspend fun deleteExpense(expense: Expense) {
        dao.deleteExpense(expense)
    }
}
