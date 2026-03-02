import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/authService.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Stream<User?> get authStateChanges => _service.authStateChanges;

  Future<void> signup(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _service.signup(email, password);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _service.login(email, password);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();
  }
}