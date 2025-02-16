import 'package:flutter/material.dart';
import 'package:menatal_health_journal/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:menatal_health_journal/models/user.dart' as appModel;

class AuthProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _checkUserSession();
  }

  // Sign up user
  Future<String?> signUp(String email, String password) async {
    appModel.User newUser = appModel.User(email: email, password: password);
    final AuthResponse? response = await _userService.signUpUser(newUser);

    if (response?.user != null) {
      _user = response!.user;
      notifyListeners();
      return null; // No error
    } else {
      return "Sign-up failed. Please try again.";
    }
  }

  // Login user
  Future<String?> login(String email, String password) async {
    final AuthResponse? response =
        await _userService.loginUser(email, password);

    if (response?.user != null) {
      _user = response!.user;
      notifyListeners();
      return null;
    } else {
      return "Login failed. Check your credentials.";
    }
  }

  // Logout user
  Future<void> logout() async {
    await _userService.logoutUser();
    _user = null;
    notifyListeners();
  }

  // Check if user session exists
  void _checkUserSession() {
    _user = _userService.getCurrentUser();
    notifyListeners();
  }
}
