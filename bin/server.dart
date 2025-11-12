// bin/server.dart
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_static/shelf_static.dart' as shelf_static;

import 'package:app_pii/backend/db.dart';
import 'package:app_pii/backend/upload_dirs.dart';
import 'package:app_pii/backend/routes/auth_routes.dart';
import 'package:app_pii/backend/routes/tecido_routes.dart';
import 'package:app_pii/backend/routes/grupo_routes.dart';
import 'package:app_pii/backend/routes/upload_routes.dart';
import 'package:app_pii/backend/routes/professor_routes.dart';

Future<void> main() async {
  // 1) Conecta no Mongo
  await initDb();

  // 2) Garante pastas de upload
  await ensureUploadDirs();

  // 3) Router principal
  final router = Router();

  // rota de teste
  router.get('/', (Request req) {
    return Response.ok('Servidor rodando e banco conectado!');
  });

  // 4) Registra rotas em módulos
  registerAuthRoutes(router);
  registerTecidoRoutes(router);
  registerGrupoRoutes(router);
  registerUploadRoutes(router);
  registerProfessorRoutes(router);


  // 5) Static handler (arquivos em /uploads)
  final staticHandler = shelf_static.createStaticHandler(
    'uploads',
    defaultDocument: null,
    listDirectories: false,
  );

  // 6) Middlewares + cascade
  final handler = Cascade()
      .add(staticHandler)
      .add(
        const Pipeline()
            .addMiddleware(logRequests())
            .addMiddleware(corsHeaders())
            .addHandler(router),
      )
      .handler;

  const port = 3000;
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  print('✅ Servidor rodando em http://localhost:${server.port}');
}
