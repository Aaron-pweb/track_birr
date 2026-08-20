import 'package:track_birr/domain/models/expense.dart';
import 'package:track_birr/data/local/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insertExpense(Expense expense) async {
    final db = await _dbHelper.database;
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteExpense(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<double> getTotalIncome() async {
    final db = await _dbHelper.database;
    var result = await db.rawQuery('SELECT SUM(amount) as total FROM expenses WHERE is_income = 1');
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as double;
    }
    return 0.0;
  }

  Future<double> getTotalExpense() async {
    final db = await _dbHelper.database;
    var result = await db.rawQuery('SELECT SUM(amount) as total FROM expenses WHERE is_income = 0');
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as double;
    }
    return 0.0;
  }
}