import 'package:flutter/material.dart';
import 'package:gallery/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String? error;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await _authService.login(email, password);
      error = null;
    } on FirebaseAuthException catch (e) {
      error = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
