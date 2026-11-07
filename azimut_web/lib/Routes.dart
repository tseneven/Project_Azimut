import 'package:azimut_web/Screen/Main/MainScreen.dart';
import 'package:azimut_web/Screen/Auth/auth_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';

  static final Map<String, WidgetBuilder> routes = {
    '/': (_) => MainScreen(),
    login: (context) => AuthScreen(
      initialEmail: ModalRoute.of(context)?.settings.arguments as String? ?? '',
    ),
    register: (_) => const AuthScreen(register: true),
  };
}
