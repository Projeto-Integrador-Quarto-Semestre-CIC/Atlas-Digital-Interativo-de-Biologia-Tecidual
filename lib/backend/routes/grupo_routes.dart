// lib/backend/routes/grupo_routes.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart' show where;

import 'package:app_pii/backend/db.dart';              // deve expor: final Db database;
import 'package:app_pii/models/grupo_tecido.dart';     // GrupoTecido + GrupoTecidoRepository
import 'package:app_pii/models/tecido.dart';           // TecidoRepository

// Cabeçalhos padrão (Content-Type + CORS, se você não estiver usando middleware global)
const _jsonHeaders = {'Content-Type': 'application/json'};

Map<String, dynamic> _grupoToJson(GrupoTecido g) => {
  'id': g.idGrupo,
  'grupo': g.grupo,
  'imagem': g.imagem,
};

void registerGrupoRoutes(Router router) {
  final grupoRepo  = GrupoTecidoRepository(database);
  final tecidoRepo = TecidoRepository(database);

  // GET /grupos
  router.get('/grupos', (Request req) async {
    try {
      final grupos = await grupoRepo.getTodos();
      return Response.ok(jsonEncode(grupos.map(_grupoToJson).toList()), headers: _jsonHeaders);
    } catch (e, st) {
      print('GET /grupos erro: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao listar grupos'}),
        headers: _jsonHeaders,
      );
    }
  });

  // POST /grupos  {grupo, imagem}
  router.post('/grupos', (Request req) async {
    try {
      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      final grupo  = (body['grupo'] ?? '').toString().trim();
      final imagem = (body['imagem'] ?? '').toString();

      if (grupo.isEmpty) {
        return Response(400,
          body: jsonEncode({'ok': false, 'message': 'Nome do grupo é obrigatório'}),
          headers: _jsonHeaders,
        );
      }

      // gera id lógico incremental
      final coll = database.collection('grupotecidos');
      final last = await coll.findOne(where.sortBy('id', descending: true));
      final novoId = (last == null)
        ? 1
        : ((last['id'] is int) ? last['id'] as int : int.parse(last['id'].toString())) + 1;

      final novo = GrupoTecido(idGrupo: novoId, grupo: grupo, imagem: imagem);
      await grupoRepo.inserir(novo);

              return Response.ok(
          jsonEncode({'ok': true, 'grupo': _grupoToJson(novo)}),
          headers: {'Content-Type': 'application/json'},);

    } catch (e, st) {
      print('POST /grupos erro: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao criar grupo'}),
        headers: _jsonHeaders,
      );
    }
  });

  // PUT /grupos/<id>  {grupo?, imagem?}
  router.put('/grupos/<id>', (Request req, String id) async {
    try {
      final idGrupo = int.tryParse(id);
      if (idGrupo == null) {
        return Response(400, body: jsonEncode({'ok': false, 'message': 'ID inválido'}), headers: _jsonHeaders);
      }

      final atual = await grupoRepo.getPorIdGrupo(idGrupo);
      if (atual == null || atual.idMongo == null) {
        return Response(404, body: jsonEncode({'ok': false, 'message': 'Grupo não encontrado'}), headers: _jsonHeaders);
      }

      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      final novoNome   = (body['grupo']  ?? atual.grupo).toString().trim();
      final novaImagem = (body['imagem'] ?? atual.imagem).toString();

      final atualizado = GrupoTecido(
        idMongo: atual.idMongo,
        idGrupo: atual.idGrupo,
        grupo: novoNome,
        imagem: novaImagem,
      );

      await grupoRepo.atualizar(atual.idMongo!.toHexString(), atualizado);
      return Response.ok(jsonEncode(_grupoToJson(atualizado)), headers: _jsonHeaders);
    } catch (e, st) {
      print('PUT /grupos/<id> erro: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao atualizar grupo'}),
        headers: _jsonHeaders,
      );
    }
  });

  // DELETE /grupos/<id>
  router.delete('/grupos/<id>', (Request req, String id) async {
    try {
      final idGrupo = int.tryParse(id);
      if (idGrupo == null) {
        return Response(400, body: jsonEncode({'ok': false, 'message': 'ID inválido'}), headers: _jsonHeaders);
      }

      final g = await grupoRepo.getPorIdGrupo(idGrupo);
      if (g == null || g.idMongo == null) {
        return Response(404, body: jsonEncode({'ok': false, 'message': 'Grupo não encontrado'}), headers: _jsonHeaders);
      }

      // apaga tecidos deste grupo (por nome de grupo)
      final tecidos = await tecidoRepo.getPorGrupo(g.grupo);
      for (final t in tecidos) {
        if (t.idMongo != null) {
          await tecidoRepo.deletar(t.idMongo!.toHexString());
        }
      }

      await grupoRepo.deletar(g.idMongo!.toHexString());
      return Response.ok(jsonEncode({'ok': true}), headers: _jsonHeaders);
    } catch (e, st) {
      print('DELETE /grupos/<id> erro: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao excluir grupo'}),
        headers: _jsonHeaders,
      );
    }
  });
}
