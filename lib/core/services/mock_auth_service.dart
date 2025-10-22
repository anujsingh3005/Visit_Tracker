// lib/core/services/mock_auth_service.dart

import 'dart:async';
import 'package:visit_tracker_app/core/models/user_model.dart';

class MockAuthService {
  final StreamController<UserModel?> _userController = StreamController<UserModel?>();
  Stream<UserModel?> get user => _userController.stream;

  // --- FIX APPLIED HERE ---
  // Added the missing required fields to both mock users.
  final _manager = UserModel(
    uid: 'manager123',
    email: 'manager@test.com',
    name: 'Alia Bhatt',
    role: 'manager',
    phone: '+91 99887 76655',
    address: '456, Juhu, Mumbai',
    designation: 'Regional Manager',
    profileImageUrl: 'https://placehold.co/100x100/A9C27A/000000?text=AB',
  );

  final _salesperson = UserModel(
    uid: 'sales123',
    email: 'sales@test.com',
    name: 'Anuj Sharma',
    role: 'salesperson',
    phone: '+91 98765 43210',
    address: '123, Marine Drive, Mumbai',
    designation: 'Sales Executive',
    profileImageUrl: 'https://placehold.co/100x100/E6E6E6/000000?text=AS',
  );
  // --- END OF FIX ---

  MockAuthService() {
    // Immediately tell the app that no user is logged in.
    _userController.add(null);
  }

  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == _manager.email) {
      _userController.add(_manager);
    } else if (email == _salesperson.email) {
      _userController.add(_salesperson);
    } else {
      _userController.add(null);
    }
  }

  Future<void> signOut() async {
    _userController.add(null);
  }

  void dispose() {
    _userController.close();
  }
}