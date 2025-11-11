import 'dart:convert';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart' show where;
import 'package:shelf_static/shelf_static.dart' as shelf_static;
import 'package:mongo_dart/mongo_dart.dart' hide State; // para usar Db, where, etc.

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:app_pii/database/grupo_tecido.dart';
import 'package:app_pii/database/tecido.dart';

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

      
    // rota para criar um novo tecido
router.post('/tecidos', (Request req) async {
  final bodyStr = await req.readAsString();
  final body = jsonDecode(bodyStr) as Map<String, dynamic>;

  final grupo = (body['grupo'] ?? '').toString();
  final tipo  = (body['tipo'] ?? '').toString();
  final nome  = (body['nome'] ?? '').toString();
  final texto = (body['texto'] ?? '').toString();
  final imagem = (body['imagem'] ?? '').toString(); // pode ser vazio por enquanto

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

  // gerar novo idTecido (id lógico)
  final coll = database.collection('tecidos');

    // pega só o último documento, ordenando por id desc
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

// lista tecidos (opcionalmente filtrando por grupo)
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

      // garante que as pastas existem
      final dirGrupos = Directory('uploads/grupos');
      if (!await dirGrupos.exists()) {
        await dirGrupos.create(recursive: true);
      }

      final dirTecidos = Directory('uploads/tecidos');
      if (!await dirTecidos.exists()) {
        await dirTecidos.create(recursive: true);
      }

    final staticHandler = shelf_static.createStaticHandler(
      'uploads',           // pasta local
      defaultDocument: null,
      listDirectories: false,
    );
    
    // rota para listar grupos de tecido
    router.get('/grupos', (Request req) async {
      final repo = GrupoTecidoRepository(database);
      final grupos = await repo.getTodos();

      final jsonList = grupos.map((g) => g.toMap()).toList();

      return Response.ok(
        jsonEncode(jsonList),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // cria um novo grupo de tecido
router.post('/grupos', (Request req) async {
  final bodyStr = await req.readAsString();
  final body = jsonDecode(bodyStr) as Map<String, dynamic>;

  final grupo  = (body['grupo'] ?? '').toString();
  final imagem = (body['imagem'] ?? '').toString();

  if (grupo.isEmpty) {
    return Response(
      400,
      body: jsonEncode({'ok': false, 'message': 'Nome do grupo é obrigatório'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  final repo = GrupoTecidoRepository(database);

  // gerar novo id lógico (idGrupo)
  final coll = database.collection('grupotecidos');
  final lastDoc =
      await coll.findOne(where.sortBy('id', descending: true));

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


// upload de imagem de GRUPO (thumb)
router.post('/upload_imagem_grupo', (Request req) async {
  try {
    final bodyStr = await req.readAsString();
    final body = jsonDecode(bodyStr) as Map<String, dynamic>;

    final nome = body['nome']?.toString();
    final bytesBase64 = body['bytes']?.toString();

    if (nome == null || nome.isEmpty || bytesBase64 == null || bytesBase64.isEmpty) {
      return Response(
        400,
        body: jsonEncode({'ok': false, 'message': 'nome e bytes são obrigatórios'}),
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
      body: jsonEncode({'ok': false, 'message': 'Erro ao salvar imagem de grupo: $e'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
});


// upload de imagem de TECIDO (full)
router.post('/upload_imagem_tecido', (Request req) async {
  try {
    final bodyStr = await req.readAsString();
    final body = jsonDecode(bodyStr) as Map<String, dynamic>;

    final nome = body['nome']?.toString();
    final bytesBase64 = body['bytes']?.toString();

    if (nome == null || nome.isEmpty || bytesBase64 == null || bytesBase64.isEmpty) {
      return Response(
        400,
        body: jsonEncode({'ok': false, 'message': 'nome e bytes são obrigatórios'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final bytes = base64Decode(bytesBase64);

    final file = File('uploads/tecidos/$nome');
    await file.writeAsBytes(bytes);

    final path = '/tecidos/$nome'; // caminho salvo no Mongo

    return Response.ok(
      jsonEncode({'ok': true, 'path': path}),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response(
      500,
      body: jsonEncode({'ok': false, 'message': 'Erro ao salvar imagem de tecido: $e'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
});

  // Middleware (log + CORS)
  final handler = Cascade()
    .add(staticHandler)              // primeiro tenta servir arquivo estático (/imagens.png etc.)
    .add(const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(corsHeaders())
        .addHandler(router))
    .handler;
  
  const port = 3000;
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  print('✅ Servidor rodando em http://localhost:$port');
}
