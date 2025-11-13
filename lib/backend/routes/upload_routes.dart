// lib/backend/routes/upload_routes.dart
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:path/path.dart' as p;

import '../conversor.dart';

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
        body:
            jsonEncode({'ok': false, 'message': 'Erro ao salvar imagem de tecido: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // POST /upload_slide  -> converte .mrxs local e retorna URL do .dzi
  router.post('/upload_slide', (Request req) async {
    try {
      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      final localPath = body['localPath']?.toString();
      if (localPath == null || localPath.isEmpty) {
        return Response(400,
            body: jsonEncode({'ok': false, 'message': 'caminho do arquivo é obrigatório'}),
            headers: {'Content-Type': 'application/json'});
      }

      final srcFile = File(localPath);
      if (!await srcFile.exists()) {
        return Response(404,
            body: jsonEncode({'ok': false, 'message': 'Arquivo não encontrado: $localPath'}),
            headers: {'Content-Type': 'application/json'});
      }

      final base = p.basenameWithoutExtension(localPath);
      final companionDir = Directory(p.join(p.dirname(localPath), base));
      if (!await companionDir.exists()) {
        return Response(400,
            body: jsonEncode({
              'ok': false,
              'message':
                  'Pasta auxiliar não encontrada ao lado do .mrxs. Verifique se a pasta "${companionDir.path}" existe.'
            }),
            headers: {'Content-Type': 'application/json'});
      }

      final dirSlides = Directory('uploads/slides');
      if (!await dirSlides.exists()) await dirSlides.create(recursive: true);

      final outDir = p.join(dirSlides.path, '${base}_dzi');
      if (!await Directory(outDir).exists()) await Directory(outDir).create(recursive: true);

      final scriptPath = p.join('bin', 'python', 'conversor.py');

      ProcessResult result;
      try {
        result = await runPythonConversor(
          scriptPath: scriptPath,
          inputPath: localPath,
          outputDir: outDir,
          extraArgs: ['--format', 'png', '--tile_size', '1024'],
        );
      } catch (e) {
        return Response.internalServerError(
            body: jsonEncode({'ok': false, 'message': 'Falha ao executar o conversor', 'error': e.toString()}),
            headers: {'Content-Type': 'application/json'});
      }

      if (result.exitCode != 0) {
        return Response.internalServerError(
            body: jsonEncode({'ok': false, 'message': 'Conversão falhou', 'stderr': result.stderr.toString()}),
            headers: {'Content-Type': 'application/json'});
      }

      final dziUrl = '/uploads/slides/${base}_dzi/$base.dzi';
      return Response.ok(jsonEncode({'ok': true, 'dzi': dziUrl}), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response(500, body: jsonEncode({'ok': false, 'message': 'Erro no servidor: ${e.toString()}'}), headers: {'Content-Type': 'application/json'});
    }
  });
}
