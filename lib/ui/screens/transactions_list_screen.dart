import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_birr/providers/expense_providers.dart';
import 'package:track_birr/ui/screens/add_transaction_screen.dart';
import 'package:intl/intl.dart';

class TransactionsListScreen extends ConsumerWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: expenses.isEmpty
          ? const Center(child: Text('No transactions found.'))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                final isIncome = expense.isIncome;

                final currencyFormatter = NumberFormat.currency(symbol: 'Birr ', decimalDigits: 2);
                final dateFormatter = DateFormat('MMM dd, yyyy HH:mm');
                final date = DateTime.fromMillisecondsSinceEpoch(expense.timestamp);

                return Dismissible(
                  key: Key(expense.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    if (expense.id != null) {
                      ref.read(expensesProvider.notifier).deleteExpense(expense.id!);
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
                        child: Icon(
                          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(expense.merchantName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expense.bankOrTelecom} • ${expense.category}\n${dateFormatter.format(date)}'),
                      trailing: Text(
                        '${isIncome ? '+' : '-'}${currencyFormatter.format(expense.amount)}',
                        style: TextStyle(
                          color: isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}