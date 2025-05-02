class ApiConfig {
  // static const String baseUrl = 'http://10.0.2.2:3000/api'; // For Android emulator
  static const String baseUrl = 'http://localhost:8000/api'; // For iOS simulator
  
  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  
  // Expense endpoints
  static const String expenses = '/expenses';
  static const String monthlyExpenses = '/expenses/month';
  static const String monthlyStats = '/expenses/stats';
}
