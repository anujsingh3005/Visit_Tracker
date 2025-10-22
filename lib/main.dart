import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visit_tracker_app/core/models/user_model.dart';
import 'package:visit_tracker_app/core/services/mock_auth_service.dart';
import 'package:visit_tracker_app/features/auth/login_screen.dart';
import 'package:visit_tracker_app/features/manager/manager_main_screen.dart';
import 'package:visit_tracker_app/features/salesperson/salesperson_main_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MockAuthService>(
          create: (_) => MockAuthService(),
          dispose: (_, service) => service.dispose(),
        ),
        StreamProvider<UserModel?>(
          create: (context) => context.read<MockAuthService>().user,
          initialData: null, 
        ),
      ],
      child: MaterialApp(
        title: 'visit_tracker_app',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
        return const LoginScreen();
    } else {
        // --- THIS IS THE UPDATE ---
        // Once a user logs in, route them based on their role.
        // The salesperson now goes to the SalespersonMainScreen with the bottom navigation.
        return user.role == 'manager' 
            ? const ManagerMainScreen() 
            : const SalespersonMainScreen();
    }
  }
}