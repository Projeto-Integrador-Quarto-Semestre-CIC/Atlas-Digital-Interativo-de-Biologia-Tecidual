import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:app_pii/database/administrador.dart';
import 'package:app_pii/database/professor.dart';

Db? db;
Db get database => db!;

Future<void> main() async {
  // conecta no Mongo
  const String mongoUri =
      'mongodb+srv://felipeduarteabc:3wPu9Wmv2KfptcM@cluster0.cthfqpb.mongodb.net/?appName=Cluster0';

  db = await Db.create(mongoUri);
  await db!.open();
  print('✅ Conectado ao MongoDB');

  final router = Router();

  // rota de teste
  router.get('/', (Request req) {
    return Response.ok('Servidor rodando e banco conectado!');
  });

  // rota de login
  router.post('/login', (Request req) async {
    final bodyString = await req.readAsString();
    final body = jsonDecode(bodyString) as Map<String, dynamic>;

    // 🔹 Agora usa "usuario" em vez de "email"
    final usuario = (body['usuario'] ?? '').toString();
    final senha   = (body['senha'] ?? '').toString();

    if (usuario.isEmpty || senha.isEmpty) {
      return Response(
        400,
        body: jsonEncode(
          {'ok': false, 'message': 'Usuário e senha obrigatórios'},
        ),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final admRepo  = AdministradorRepository(database);
    final profRepo = ProfessorRepository(database);

    // 👉 tenta ADMIN pelo nome (usuario)
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

    // 👉 tenta PROFESSOR pelo nome (usuario)
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

    // ninguém encontrado
    return Response.ok(
      jsonEncode({'ok': false, 'message': 'Credenciais inválidas'}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Middleware (log + CORS)
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router);

  const port = 3000;
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  print('✅ Servidor rodando em http://localhost:$port');
}
