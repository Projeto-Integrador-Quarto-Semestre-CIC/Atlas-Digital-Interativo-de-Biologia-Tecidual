// lib/backend/routes/upload_routes.dart
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

void registerUploadRoutes(Router router) {
  // POST /upload_imagem_grupo
  router.post('/upload_imagem_grupo', (Request req) async {
    try {
      final bodyStr = await req.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final nome = body['nome']?.toString();
      final bytesBase64 = body['bytes']?.toString();

      if (nome == null ||
          nome.isEmpty ||
          bytesBase64 == null ||
          bytesBase64.isEmpty) {
        return Response(
          400,
          body: jsonEncode(
              {'ok': false, 'message': 'nome e bytes são obrigatórios'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final bytes = base64Decode(bytesBase64);

      final dirGrupos = Directory('uploads/grupos');
      if (!await dirGrupos.exists()) {
        await dirGrupos.create(recursive: true);
      }

      final file = File('uploads/grupos/$nome');
      await file.writeAsBytes(bytes);

      final path = '/grupos/$nome';

      return Response.ok(
        jsonEncode({'ok': true, 'path': path}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode(
            {'ok': false, 'message': 'Erro ao salvar imagem de grupo: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // POST /upload_imagem_tecido
  router.post('/upload_imagem_tecido', (Request req) async {
    try {
      final bodyStr = await req.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final nome = body['nome']?.toString();
      final bytesBase64 = body['bytes']?.toString();

      if (nome == null ||
          nome.isEmpty ||
          bytesBase64 == null ||
          bytesBase64.isEmpty) {
        return Response(
          400,
          body: jsonEncode(
              {'ok': false, 'message': 'nome e bytes são obrigatórios'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final bytes = base64Decode(bytesBase64);

      final dirTecidos = Directory('uploads/tecidos');
      if (!await dirTecidos.exists()) {
        await dirTecidos.create(recursive: true);
      }

      final file = File('uploads/tecidos/$nome');
      await file.writeAsBytes(bytes);

      final path = '/tecidos/$nome';

      return Response.ok(
        jsonEncode({'ok': true, 'path': path}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode(
            {'ok': false, 'message': 'Erro ao salvar imagem de tecido: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });
}
