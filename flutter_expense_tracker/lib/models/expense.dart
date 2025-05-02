class Expense {
  final int id;
  final int userId;
  final double amount;
  final String category;
  final DateTime date;
  final String? notes;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['ID'],
      userId: json['USER_ID'],
      amount: double.parse(json['AMOUNT'].toString()),
      category: json['CATEGORY'],
      date: DateTime.parse(json['DATE']),
      notes: json['NOTES'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
      'date': date.toIso8601String().split('T')[0],
      'notes': notes,
    };
  }
}
