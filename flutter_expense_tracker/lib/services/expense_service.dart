import 'dart:convert';
import 'package:expense_tracker/config/api_config.dart';
import 'package:expense_tracker/models/category_stat.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:http/http.dart' as http;


class ExpenseService {
  final String token;
  
  ExpenseService({required this.token});
  
  Future<List<Expense>> getAllExpenses() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.expenses),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Expense.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load expenses');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<List<Expense>> getMonthlyExpenses(int year, int month) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.monthlyExpenses}/$year/${month.toString().padLeft(2, '0')}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Expense.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load monthly expenses');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<List<CategoryStat>> getMonthlyStats(int year, int month) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.monthlyStats}/$year/${month.toString().padLeft(2, '0')}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CategoryStat.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load monthly statistics');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<int> addExpense(Expense expense) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.expenses),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(expense.toJson()),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        return data['expenseId'];
      } else {
        throw Exception(data['error'] ?? 'Failed to add expense');
      }
    } catch (e) {
      rethrow;
    }
  }
}
