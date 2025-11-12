// lib/backend/routes/tecido_routes.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart' show where;

import 'package:app_pii/backend/db.dart';          // final Db database;
import 'package:app_pii/models/tecido.dart';       // Tecido + TecidoRepository

const _jsonHeaders = {'Content-Type': 'application/json'};

Map<String, dynamic> _tecidoToJson(Tecido t) => {
  'id': t.idTecido,
  'grupo': t.grupo,
  'tipo': t.tipo,
  'nome': t.nome,
  'texto': t.texto,
  'imagem': t.imagem,
};

void registerTecidoRoutes(Router router) {
  final repo = TecidoRepository(database);

  // GET /tecidos?grupo=ABC
  router.get('/tecidos', (Request req) async {
    try {
      final grupo = req.requestedUri.queryParameters['grupo'];
      final list = (grupo != null && grupo.isNotEmpty)
          ? await repo.getPorGrupo(grupo)
          : await repo.getTodos();

      return Response.ok(jsonEncode(list.map(_tecidoToJson).toList()), headers: _jsonHeaders);
    } catch (e, st) {
      print('GET /tecidos erro: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao listar tecidos'}),
        headers: _jsonHeaders,
      );
    }
  });

  // GET /tecidos/<id> (id lógico)
  router.get('/tecidos/<id>', (Request req, String id) async {
    try {
      final idTecido = int.tryParse(id);
      if (idTecido == null) {
        return Response(400, body: jsonEncode({'ok': false, 'message': 'ID inválido'}), headers: _jsonHeaders);
      }

      final t = await repo.getPorIdTecido(idTecido);
      if (t == null) {
        return Response(404, body: jsonEncode({'ok': false, 'message': 'Tecido não encontrado'}), headers: _jsonHeaders);
      }

      return Response.ok(jsonEncode(_tecidoToJson(t)), headers: _jsonHeaders);
    } catch (e, st) {
      print('GET /tecidos/<id> erro: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao buscar tecido'}),
        headers: _jsonHeaders,
      );
    }
  });

  // POST /tecidos  {grupo, tipo, nome, texto, imagem}
  router.post('/tecidos', (Request req) async {
    try {
      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      final grupo  = (body['grupo'] ?? '').toString().trim();
      final tipo   = (body['tipo']  ?? '').toString().trim();
      final nome   = (body['nome']  ?? '').toString().trim();
      final texto  = (body['texto'] ?? '').toString();
      final imagem = (body['imagem'] ?? '').toString();

      if (grupo.isEmpty || tipo.isEmpty || nome.isEmpty) {
        return Response(400,
          body: jsonEncode({'ok': false, 'message': 'grupo, tipo e nome são obrigatórios'}),
          headers: _jsonHeaders,
        );
      }

      // id lógico incremental
      final coll = database.collection('tecidos');
      final last = await coll.findOne(where.sortBy('id', descending: true));
      final novoId = (last == null)
          ? 1
          : ((last['id'] is int) ? last['id'] as int : int.parse(last['id'].toString())) + 1;

      final novo = Tecido(
        idTecido: novoId,
        grupo: grupo,
        tipo: tipo,
        nome: nome,
        texto: texto,
        imagem: imagem,
      );

      await repo.inserir(novo);
        return Response.ok(jsonEncode({
      'ok': true,
      'tecido': _tecidoToJson(novo),}),headers: _jsonHeaders,
    );

    } catch (e, st) {
      print('POST /tecidos erro: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao criar tecido'}),
        headers: _jsonHeaders,
      );
    }
  });

  // PUT /tecidos/<id>  {grupo?, tipo?, nome?, texto?, imagem?}
  router.put('/tecidos/<id>', (Request req, String id) async {
    try {
      final idTecido = int.tryParse(id);
      if (idTecido == null) {
        return Response(400, body: jsonEncode({'ok': false, 'message': 'ID inválido'}), headers: _jsonHeaders);
      }

      final atual = await repo.getPorIdTecido(idTecido);
      if (atual == null || atual.idMongo == null) {
        return Response(404, body: jsonEncode({'ok': false, 'message': 'Tecido não encontrado'}), headers: _jsonHeaders);
      }

      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;

      final novo = Tecido(
        idMongo: atual.idMongo,
        idTecido: atual.idTecido,
        grupo:  (body['grupo']  ?? atual.grupo).toString().trim(),
        tipo:   (body['tipo']   ?? atual.tipo).toString().trim(),
        nome:   (body['nome']   ?? atual.nome).toString().trim(),
        texto:  (body['texto']  ?? atual.texto).toString(),
        imagem: (body['imagem'] ?? atual.imagem).toString(),
      );

      await repo.atualizar(atual.idMongo!.toHexString(), novo);
      return Response.ok(jsonEncode(_tecidoToJson(novo)), headers: _jsonHeaders);
    } catch (e, st) {
      print('PUT /tecidos/<id> erro: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao atualizar tecido'}),
        headers: _jsonHeaders,
      );
    }
  });

  // DELETE /tecidos/<id>
  router.delete('/tecidos/<id>', (Request req, String id) async {
    try {
      final idTecido = int.tryParse(id);
      if (idTecido == null) {
        return Response(400, body: jsonEncode({'ok': false, 'message': 'ID inválido'}), headers: _jsonHeaders);
      }

      final t = await repo.getPorIdTecido(idTecido);
      if (t == null || t.idMongo == null) {
        return Response(404, body: jsonEncode({'ok': false, 'message': 'Tecido não encontrado'}), headers: _jsonHeaders);
      }

      await repo.deletar(t.idMongo!.toHexString());
      return Response.ok(jsonEncode({'ok': true}), headers: _jsonHeaders);
    } catch (e, st) {
      print('DELETE /tecidos/<id> erro: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao excluir tecido'}),
        headers: _jsonHeaders,
      );
    }
  });
}
