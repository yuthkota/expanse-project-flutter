import 'package:flutter/material.dart';
import 'package:expense_tracker/models/category_stat.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  final List<CategoryStat> stats;

  const ExpenseChart({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No data available for analytics'),
        ),
      );
    }

    // Generate colors for pie chart sections
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    // Calculate total amount
    double totalAmount = 0;
    for (var stat in stats) {
      totalAmount += stat.total;
    }

    // Prepare data for pie chart
    final List<PieChartSectionData> sections = [];
    for (int i = 0; i < stats.length; i++) {
      final stat = stats[i];
      final double percentage = (stat.total / totalAmount) * 100;

      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: stat.total,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Expense Distribution by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                for (int i = 0; i < stats.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: colors[i % colors.length],
                        ),
                        const SizedBox(width: 8),
                        Text(stats[i].category),
                        const Spacer(),
                        Text('\$${stats[i].total.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
