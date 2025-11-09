import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth {
  // Observar login
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  static String? currentName;
  static String? currentRole;

  
  
  static const String _baseUrl = 'http://localhost:3000';

  static Future<bool> login(String usuario, String senha) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': usuario,
          'senha': senha,
        }),
      );

      if (resp.statusCode != 200) {
        print('Erro HTTP: ${resp.statusCode} - ${resp.body}');
        isLoggedIn.value = false;
        currentName = null;
        currentRole = null;
        return false;
      }

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final ok = data['ok'] == true;

      if (ok) {
        final role = data['role']?.toString();
        final nome = data['nome']?.toString();

        currentRole = role;
        currentName = nome;
        isLoggedIn.value = true; // 👈 AGORA MARCA COMO LOGADO

        print('Login OK como $role: $nome');
      } else {
        print('Login falhou: ${data['message']}');
        isLoggedIn.value = false;
        currentName = null;
        currentRole = null;
      }

      return ok;
    } catch (e) {
      print('Erro na requisição de login: $e');
      isLoggedIn.value = false;
      currentName = null;
      currentRole = null;
      return false;
    }
  }

  static void logout() {
    isLoggedIn.value = false;
    currentName = null;
    currentRole = null;
  }
}
