import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_birr/data/repository/expense_repository.dart';
import 'package:track_birr/domain/models/expense.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

final expensesProvider = NotifierProvider<ExpenseNotifier, List<Expense>>(() {
  return ExpenseNotifier();
});

class ExpenseNotifier extends Notifier<List<Expense>> {
  @override
  List<Expense> build() {
    loadExpenses();
    return [];
  }

  Future<void> loadExpenses() async {
    final repository = ref.read(expenseRepositoryProvider);
    final expenses = await repository.getAllExpenses();
    state = expenses;
  }

  Future<void> addExpense(Expense expense) async {
    final repository = ref.read(expenseRepositoryProvider);
    await repository.insertExpense(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(int id) async {
    final repository = ref.read(expenseRepositoryProvider);
    await repository.deleteExpense(id);
    await loadExpenses();
  }
}

// Derived providers for dashboard
final totalIncomeProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(expenseRepositoryProvider);
  // Watch expensesProvider so this invalidates when expenses change
  ref.watch(expensesProvider);
  return repository.getTotalIncome();
});

final totalExpenseProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(expenseRepositoryProvider);
  ref.watch(expensesProvider);
  return repository.getTotalExpense();
});

final balanceProvider = FutureProvider<double>((ref) async {
  final income = await ref.watch(totalIncomeProvider.future);
  final expense = await ref.watch(totalExpenseProvider.future);
  return income - expense;
});

final categoryExpensesProvider = Provider<Map<String, double>>((ref) {
  final expenses = ref.watch(expensesProvider);
  final map = <String, double>{};

  for (var expense in expenses) {
    if (!expense.isIncome) {
      if (map.containsKey(expense.category)) {
        map[expense.category] = map[expense.category]! + expense.amount;
      } else {
        map[expense.category] = expense.amount;
      }
    }
  }
  return map;
});