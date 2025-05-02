import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/services/auth_service.dart';
import 'package:expense_tracker/screens/home/home_screen.dart';
import 'package:expense_tracker/widgets/auth/login_form.dart';
import 'package:expense_tracker/widgets/auth/register_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _submitAuthForm(
    String username,
    String email,
    String password,
    BuildContext context,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      
      if (_isLogin) {
        await authService.login(username, password);
      } else {
        await authService.register(username, email, password);
      }
      
      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Expense Tracker',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    _isLogin ? 'Login' : 'Create Account',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (_isLogin)
                    LoginForm(
                      onSubmit: _submitAuthForm,
                      isLoading: _isLoading,
                    )
                  else
                    RegisterForm(
                      onSubmit: _submitAuthForm,
                      isLoading: _isLoading,
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      _isLogin ? 'Create an account' : 'I already have an account',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
