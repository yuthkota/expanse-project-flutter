import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseList({
    Key? key,
    required this.expenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No expenses found for this month'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) {
          final expense = expenses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('\$${expense.amount.toStringAsFixed(0)}'),
                  ),
                ),
              ),
              title: Text(expense.category),
              subtitle: Text(
                '${DateFormat('yyyy-MM-dd').format(expense.date)}${expense.notes != null ? '\n${expense.notes}' : ''}',
              ),
              trailing: Text(
                '\$${expense.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
