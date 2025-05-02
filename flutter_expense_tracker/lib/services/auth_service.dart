import 'dart:convert';
import 'package:expense_tracker/config/api_config.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService extends ChangeNotifier {
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');
    final username = prefs.getString('username');
    
    if (token != null && userId != null && username != null) {
      _currentUser = User(
        id: userId,
        username: username,
        token: token,
      );
      notifyListeners();
      return true;
    }
    return false;
  }
  
  Future<User?> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        return await login(username, password);
      } else {
        throw Exception(data['error'] ?? 'Registration failed');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['token'] != null) {
        final user = User.fromJson(data);
        
        // Save user data to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token!);
        await prefs.setInt('userId', user.id);
        await prefs.setString('username', user.username);
        
        _currentUser = user;
        notifyListeners();
        return user;
      } else {
        throw Exception(data['error'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
    notifyListeners();
  }
}
