package com.example.track_birr.data.local

import androidx.room.Database
import androidx.room.RoomDatabase

@Database(entities = [Expense::class], version = 2, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun expenseDao(): ExpenseDao
}
