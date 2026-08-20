import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:track_birr/providers/expense_providers.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceProvider);
    final incomeAsync = ref.watch(totalIncomeProvider);
    final expenseAsync = ref.watch(totalExpenseProvider);
    final categoryExpenses = ref.watch(categoryExpensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryCard(context, 'Total Balance', balanceAsync, isBalance: true),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSummaryCard(context, 'Income', incomeAsync, isIncome: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildSummaryCard(context, 'Expenses', expenseAsync, isIncome: false)),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Expenses by Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (categoryExpenses.isEmpty)
              const Center(child: Text('No expense data to display.'))
            else
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: _buildPieChartSections(categoryExpenses),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, AsyncValue<double> asyncValue, {bool isBalance = false, bool? isIncome}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            asyncValue.when(
              data: (value) {
                Color textColor = Colors.black;
                if (!isBalance && isIncome != null) {
                  textColor = isIncome ? Colors.green : Colors.red;
                } else if (isBalance) {
                  textColor = value >= 0 ? Colors.green : Colors.red;
                }

                final currencyFormatter = NumberFormat.currency(symbol: 'Birr ', decimalDigits: 2);
                return Text(
                  currencyFormatter.format(value),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: textColor, fontWeight: FontWeight.bold),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, double> data) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    int colorIndex = 0;
    return data.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;

      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        color: color,
        radius: 100,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }
}