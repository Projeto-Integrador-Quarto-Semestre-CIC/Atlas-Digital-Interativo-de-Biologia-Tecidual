// lib/backend/routes/professor_routes.dart
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart' show where;

import 'package:app_pii/backend/db.dart';
import 'package:app_pii/models/professor.dart';

/// Converte Professor -> Map pronto pra JSON (sem ObjectId bruto)
Map<String, dynamic> _professorToJson(Professor p) {
  return {
    'id': p.idProfessor, // ID lógico usado pelo frontend
    'nome': p.nome,
    'email': p.email,
    'senha': p.senha,
  };
}

void registerProfessorRoutes(Router router) {
  final repo = ProfessorRepository(database);

  // ============================
  // GET /professores - lista todos
  // ============================
  router.get('/professores', (Request req) async {
    try {
      final professores = await repo.getTodos();
      final listaJson = professores.map(_professorToJson).toList();

      return Response.ok(
        jsonEncode(listaJson),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      print('Erro em GET /professores: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao listar professores'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // ============================
  // GET /professores/<id> - busca por idProfessor
  // ============================
  router.get('/professores/<id>', (Request req, String id) async {
    try {
      final idProfessor = int.tryParse(id);
      if (idProfessor == null) {
        return Response(
          400,
          body: jsonEncode({'ok': false, 'message': 'ID inválido'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final coll = database.collection('professores');
      final doc = await coll.findOne({'idProfessor': idProfessor});
      if (doc == null) {
        return Response(
          404,
          body: jsonEncode({'ok': false, 'message': 'Professor não encontrado'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final prof = Professor.fromMap(doc);
      return Response.ok(
        jsonEncode(_professorToJson(prof)),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      print('Erro em GET /professores/<id>: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao buscar professor'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // ============================
  // POST /professores - cria novo
  // body: { nome, email, senha }
  // ============================
  router.post('/professores', (Request req) async {
    try {
      final bodyStr = await req.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final nome = (body['nome'] ?? '').toString().trim();
      final email = (body['email'] ?? '').toString().trim();
      final senha = (body['senha'] ?? '').toString();

      if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
        return Response(
          400,
          body: jsonEncode({
            'ok': false,
            'message': 'nome, email e senha são obrigatórios',
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // gerar novo idProfessor sequencial
      final coll = database.collection('professores');
      final lastDoc =
          await coll.findOne(where.sortBy('idProfessor', descending: true));

      int novoId = 1;
      if (lastDoc != null) {
        final lastId = lastDoc['idProfessor'];
        novoId =
            (lastId is int ? lastId : int.parse(lastId.toString())) + 1;
      }

      final novoProf = Professor(
        idProfessor: novoId,
        nome: nome,
        email: email,
        senha: senha,
      );

      await repo.inserir(novoProf);

      return Response.ok(
        jsonEncode(_professorToJson(novoProf)),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      print('Erro em POST /professores: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao criar professor'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // ============================
  // PUT /professores/<id> - atualiza por idProfessor
  // body: { nome?, email?, senha? }
  // ============================
  router.put('/professores/<id>', (Request req, String id) async {
    try {
      final idProfessor = int.tryParse(id);
      if (idProfessor == null) {
        return Response(
          400,
          body: jsonEncode({'ok': false, 'message': 'ID inválido'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final bodyStr = await req.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final coll = database.collection('professores');
      final doc = await coll.findOne({'idProfessor': idProfessor});
      if (doc == null) {
        return Response(
          404,
          body: jsonEncode({'ok': false, 'message': 'Professor não encontrado'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final atual = Professor.fromMap(doc);

      final novoNome =
          (body['nome'] ?? atual.nome).toString().trim();
      final novoEmail =
          (body['email'] ?? atual.email).toString().trim();
      final novaSenha =
          (body['senha'] ?? atual.senha).toString();

      final atualizado = Professor(
        id: atual.id, // mantém o _id do Mongo
        idProfessor: atual.idProfessor,
        nome: novoNome,
        email: novoEmail,
        senha: novaSenha,
      );

      // usa o repository com o _id original
      await repo.atualizar(atual.id!.toHexString(), atualizado);

      return Response.ok(
        jsonEncode(_professorToJson(atualizado)),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      print('Erro em PUT /professores/<id>: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao atualizar professor'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // ============================
  // DELETE /professores/<id> - remove por idProfessor
  // ============================
  router.delete('/professores/<id>', (Request req, String id) async {
    try {
      final idProfessor = int.tryParse(id);
      if (idProfessor == null) {
        return Response(
          400,
          body: jsonEncode({'ok': false, 'message': 'ID inválido'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final coll = database.collection('professores');
      final doc = await coll.findOne({'idProfessor': idProfessor});
      if (doc == null) {
        return Response(
          404,
          body: jsonEncode({'ok': false, 'message': 'Professor não encontrado'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final prof = Professor.fromMap(doc);
      await repo.deletar(prof.id!.toHexString());

      return Response.ok(
        jsonEncode({'ok': true}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      print('Erro em DELETE /professores/<id>: $e\n$st');
      return Response.internalServerError(
        body: jsonEncode({'ok': false, 'message': 'Erro ao excluir professor'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });
}
