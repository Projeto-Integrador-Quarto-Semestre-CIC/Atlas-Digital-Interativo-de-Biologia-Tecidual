// lib/backend/routes/auth_routes.dart
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:app_pii/backend/db.dart';
import 'package:app_pii/models/administrador.dart';
import 'package:app_pii/models/professor.dart';

void registerAuthRoutes(Router router) {
  // POST /login
  router.post('/login', (Request req) async {
    final bodyString = await req.readAsString();
    final body = jsonDecode(bodyString) as Map<String, dynamic>;

    final usuario = (body['usuario'] ?? '').toString();
    final senha = (body['senha'] ?? '').toString();

    if (usuario.isEmpty || senha.isEmpty) {
      return Response(
        400,
        body: jsonEncode(
          {'ok': false, 'message': 'Usuário e senha obrigatórios'},
        ),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final admRepo = AdministradorRepository(database);
    final profRepo = ProfessorRepository(database);

    final adm = await admRepo.getPorNome(usuario);
    if (adm != null && adm.senha == senha) {
      return Response.ok(
        jsonEncode({
          'ok': true,
          'role': 'admin',
          'nome': adm.nome,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final prof = await profRepo.getPorNome(usuario);
    if (prof != null && prof.senha == senha) {
      return Response.ok(
        jsonEncode({
          'ok': true,
          'role': 'professor',
          'nome': prof.nome,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    return Response.ok(
      jsonEncode({'ok': false, 'message': 'Credenciais inválidas'}),
      headers: {'Content-Type': 'application/json'},
    );
  });
}
