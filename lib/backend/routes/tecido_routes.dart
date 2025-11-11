import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart' show where;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:app_pii/models/tecido.dart';
import 'package:app_pii/backend/db.dart'; // para usar `database`

void registerTecidoRoutes(Router router) {
  
  // POST /tecidos – criar novo tecido
  router.post('/tecidos', (Request req) async {
    final bodyStr = await req.readAsString();
    final body = jsonDecode(bodyStr) as Map<String, dynamic>;

    final grupo = (body['grupo'] ?? '').toString();
    final tipo = (body['tipo'] ?? '').toString();
    final nome = (body['nome'] ?? '').toString();
    final texto = (body['texto'] ?? '').toString();
    final imagem = (body['imagem'] ?? '').toString(); // pode ser vazio

    if (grupo.isEmpty || tipo.isEmpty || nome.isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'ok': false,
          'message': 'grupo, tipo e nome são obrigatórios',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final repo = TecidoRepository(database);

    // gerar novo idTecido
    final coll = database.collection('tecidos');

    final lastDoc = await coll.findOne(where.sortBy('id', descending: true));

    int novoId = 1;
    if (lastDoc != null) {
      final lastId = lastDoc['id'];
      novoId = (lastId is int ? lastId : int.parse(lastId.toString())) + 1;
    }

    final tecido = Tecido(
      idTecido: novoId,
      grupo: grupo,
      tipo: tipo,
      nome: nome,
      texto: texto,
      imagem: imagem,
    );

    await repo.inserir(tecido);

    return Response.ok(
      jsonEncode({'ok': true, 'id': novoId}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // GET /tecidos – lista (opcionalmente filtrando por grupo)
  router.get('/tecidos', (Request req) async {
    final params = req.requestedUri.queryParameters;
    final grupo = params['grupo'];

    final repo = TecidoRepository(database);
    List<Tecido> tecidos;

    if (grupo != null && grupo.isNotEmpty) {
      tecidos = await repo.getPorGrupo(grupo);
    } else {
      tecidos = await repo.getTodos();
    }

    final jsonList = tecidos.map((t) => t.toMap()).toList();

    return Response.ok(
      jsonEncode(jsonList),
      headers: {'Content-Type': 'application/json'},
    );
  });
}
