import 'package:mongo_dart/mongo_dart.dart';

/// ========================
///  MODEL: GrupoTecido
/// ========================
class GrupoTecido {
  ObjectId? _id;        // _id do Mongo
  int _idGrupo;         // campo "id" lógico
  String _grupo;        // nome do grupo
  String _imagem;       // caminho/URL/base64

  GrupoTecido({
    ObjectId? idMongo,
    required int idGrupo,
    required String grupo,
    required String imagem,
  })  : _id = idMongo,
        _idGrupo = idGrupo,
        _grupo = grupo,
        _imagem = imagem;

  // GETTERS
  ObjectId? get idMongo => _id;
  int get idGrupo => _idGrupo;
  String get grupo => _grupo;
  String get imagem => _imagem;

  // SETTERS (opcionais)
  set grupoNome(String v) => _grupo = v;
  set imagem(String v) => _imagem = v;

  // Mongo -> Dart
  factory GrupoTecido.fromMap(Map<String, dynamic> map) {
    return GrupoTecido(
      idMongo: map['_id'] as ObjectId?,
      idGrupo: map['id'] is int
          ? map['id']
          : int.parse(map['id'].toString()),
      grupo: map['grupo'] as String,
      imagem: map['imagem'] as String,
    );
  }

  // Dart -> Mongo
  Map<String, dynamic> toMap() {
    return {
      if (_id != null) '_id': _id,
      'id': _idGrupo,
      'grupo': _grupo,
      'imagem': _imagem,
    };
  }
}

/// ========================
///  REPOSITORY: GrupoTecidos
/// ========================
class GrupoTecidoRepository {
  final Db _db;
  late final DbCollection _collection;

  GrupoTecidoRepository(this._db) {
    _collection = _db.collection('grupotecidos'); // nome da coleção
  }

  // GET: todos os grupos
  Future<List<GrupoTecido>> getTodos() async {
    final docs = await _collection.find().toList();
    return docs.map((d) => GrupoTecido.fromMap(d)).toList();
  }

  // GET: por _id do Mongo
  Future<GrupoTecido?> getPorIdMongo(String idMongo) async {
    final objectId = ObjectId.fromHexString(idMongo);
    final doc = await _collection.findOne({'_id': objectId});
    return doc != null ? GrupoTecido.fromMap(doc) : null;
  }

  // GET: por id lógico (campo "id")
  Future<GrupoTecido?> getPorIdGrupo(int idGrupo) async {
    final doc = await _collection.findOne({'id': idGrupo});
    return doc != null ? GrupoTecido.fromMap(doc) : null;
  }

  // GET: por nome do grupo
  Future<GrupoTecido?> getPorNomeGrupo(String grupo) async {
    final doc = await _collection.findOne({'grupo': grupo});
    return doc != null ? GrupoTecido.fromMap(doc) : null;
  }

  // Inserir
  Future<void> inserir(GrupoTecido grupoTecido) async {
    await _collection.insertOne(grupoTecido.toMap());
  }

  // Atualizar
  Future<void> atualizar(String idMongo, GrupoTecido grupoTecido) async {
    final objectId = ObjectId.fromHexString(idMongo);
    await _collection.replaceOne({'_id': objectId}, grupoTecido.toMap());
  }

  // Deletar
  Future<void> deletar(String idMongo) async {
    final objectId = ObjectId.fromHexString(idMongo);
    await _collection.deleteOne({'_id': objectId});
  }
}
