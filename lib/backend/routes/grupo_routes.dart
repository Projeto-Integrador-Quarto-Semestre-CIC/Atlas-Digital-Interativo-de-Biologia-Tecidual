// lib/backend/routes/grupo_routes.dart
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart' show where;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:app_pii/models/grupo_tecido.dart';
import 'package:app_pii/backend/db.dart';

void registerGrupoRoutes(Router router) {
  
  // GET /grupos – lista todos
  router.get('/grupos', (Request req) async {
    final repo = GrupoTecidoRepository(database);
    final grupos = await repo.getTodos();

    final jsonList = grupos.map((g) => g.toMap()).toList();

    return Response.ok(
      jsonEncode(jsonList),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // POST /grupos – cria novo grupo
  router.post('/grupos', (Request req) async {
    final bodyStr = await req.readAsString();
    final body = jsonDecode(bodyStr) as Map<String, dynamic>;

    final grupo = (body['grupo'] ?? '').toString();
    final imagem = (body['imagem'] ?? '').toString();

    if (grupo.isEmpty) {
      return Response(
        400,
        body:
            jsonEncode({'ok': false, 'message': 'Nome do grupo é obrigatório'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final repo = GrupoTecidoRepository(database);

    final coll = database.collection('grupotecidos');
    final lastDoc = await coll.findOne(where.sortBy('id', descending: true));

    int novoId = 1;
    if (lastDoc != null) {
      final lastId = lastDoc['id'];
      novoId = (lastId is int ? lastId : int.parse(lastId.toString())) + 1;
    }

    final novoGrupo = GrupoTecido(
      idGrupo: novoId,
      grupo: grupo,
      imagem: imagem,
    );

    await repo.inserir(novoGrupo);

    return Response.ok(
      jsonEncode({'ok': true, 'id': novoId}),
      headers: {'Content-Type': 'application/json'},
    );
  });
}
