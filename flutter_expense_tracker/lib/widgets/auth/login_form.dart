import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Function(String username, String email, String password, BuildContext context) onSubmit;
  final bool isLoading;

  const LoginForm({
    Key? key,
    required this.onSubmit,
    required this.isLoading,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _usernameController.text,
        '', // Email not needed for login
        _passwordController.text,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          if (widget.isLoading)
            const CircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: _submit,
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
