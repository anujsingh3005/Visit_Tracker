// lib/features/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visit_tracker_app/core/services/mock_auth_service.dart';
import 'package:visit_tracker_app/shared/widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final authService = Provider.of<MockAuthService>(context, listen: false);
    await authService.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    // AuthWrapper will handle navigation. No need to check mounted here
    // because navigation happens automatically via the stream.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Text('LOGO', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController..text = 'manager@test.com',
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController..text = 'password',
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const LoadingIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black, foregroundColor: Colors.white,
                  ),
                  onPressed: _login,
                  child: const Text('LOGIN'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}