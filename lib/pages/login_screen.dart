import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:menatal_health_journal/pages/home_page.dart';
import 'package:menatal_health_journal/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  // Authenticate User (Login)
  Future<String?> _authUser(LoginData data, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return await authProvider.login(data.name, data.password);
  }

  // Sign Up User
  Future<String?> _signupUser(SignupData data, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return await authProvider.signUp(data.name!, data.password!);
  }

  // Recover Password
  Future<String?> _recoverPassword(String name, BuildContext context) async {
    // Supabase does not support direct password recovery, so you might need to send a reset link
    debugPrint('Recover password for: $name');
    return Future.delayed(loginTime).then((_) {
      return "Password recovery is not implemented yet.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: AssetImage("images/app_main.png"),
      onLogin: (data) => _authUser(data, context),
      onSignup: (data) => _signupUser(data, context),
      onRecoverPassword: (name) => _recoverPassword(name, context),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      },
    );
  }
}
