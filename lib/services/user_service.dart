import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:menatal_health_journal/models/user.dart' as appModel;

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign up method
  Future<AuthResponse?> signUpUser(appModel.User newUser) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: newUser.email,
        password: newUser.password,
      );

      if (response.user != null) {
        print('User signed up successfully: ${response.user!.email}');
        return response;
      } else {
        print('Signup failed');
        return null;
      }
    } catch (e) {
      print('Error during signup: $e');
      return null;
    }
  }

  // Login method
  Future<AuthResponse?> loginUser(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('User logged in successfully: ${response.user!.email}');
        return response;
      } else {
        print('Login failed');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // Logout method
  Future<void> logoutUser() async {
    try {
      await _supabase.auth.signOut();
      print("User logged out successfully");
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  // Check if user is logged in
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}
