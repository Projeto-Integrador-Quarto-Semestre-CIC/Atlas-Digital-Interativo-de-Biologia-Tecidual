import 'package:flutter/foundation.dart';

class Auth {
  // ValueNotifier to allow widgets to react when login state changes
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  // Simple simulated login: returns true if credentials match
  // Default credentials: admin / admin
  static Future<bool> login(String username, String password) async {
    // simulate delay
    await Future.delayed(const Duration(milliseconds: 200));
    final ok = username == 'admin' && password == 'admin';
    isLoggedIn.value = ok;
    return ok;
  }

  static void logout() {
    isLoggedIn.value = false;
  }
}
