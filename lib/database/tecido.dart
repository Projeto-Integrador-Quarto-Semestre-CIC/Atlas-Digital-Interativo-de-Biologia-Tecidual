import 'package:mongo_dart/mongo_dart.dart';

/// ========================
///  MODEL: Tecido
/// ========================
class Tecido {
  ObjectId? _id;          // _id do Mongo
  int _idTecido;          // campo "id" lógico
  int _grupo;             // id do grupo (ajuste para String se precisar)
  String _tipo;
  String _texto;
  String _imagem;

  Tecido({
    ObjectId? idMongo,
    required int idTecido,
    required int grupo,
    required String tipo,
    required String texto,
    required String imagem,
  })  : _id = idMongo,
        _idTecido = idTecido,
        _grupo = grupo,
        _tipo = tipo,
        _texto = texto,
        _imagem = imagem;

  // GETTERS
  ObjectId? get idMongo => _id;
  int get idTecido => _idTecido;
  int get grupo => _grupo;
  String get tipo => _tipo;
  String get texto => _texto;
  String get imagem => _imagem;

  // SETTERS (opcionais)
  set grupo(int v) => _grupo = v;
  set tipo(String v) => _tipo = v;
  set texto(String v) => _texto = v;
  set imagem(String v) => _imagem = v;

  // Mongo -> Dart
  factory Tecido.fromMap(Map<String, dynamic> map) {
    return Tecido(
      idMongo: map['_id'] as ObjectId?,
      idTecido: map['id'] is int
          ? map['id']
          : int.parse(map['id'].toString()),
      grupo: map['grupo'] is int
          ? map['grupo']
          : int.parse(map['grupo'].toString()),
      tipo: map['tipo'] as String,
      texto: map['texto'] as String,
      imagem: map['imagem'] as String,
    );
  }

  // Dart -> Mongo
  Map<String, dynamic> toMap() {
    return {
      if (_id != null) '_id': _id,
      'id': _idTecido,
      'grupo': _grupo,
      'tipo': _tipo,
      'texto': _texto,
      'imagem': _imagem,
    };
  }
}

/// ========================
///  REPOSITORY: Tecidos
/// ========================
class TecidoRepository {
  final Db _db;
  late final DbCollection _collection;

  TecidoRepository(this._db) {
    _collection = _db.collection('tecidos'); // nome da coleção
  }

  // GET: todos os tecidos
  Future<List<Tecido>> getTodos() async {
    final docs = await _collection.find().toList();
    return docs.map((d) => Tecido.fromMap(d)).toList();
  }

  // GET: por _id do Mongo (hex string)
  Future<Tecido?> getPorIdMongo(String idMongo) async {
    final objectId = ObjectId.fromHexString(idMongo);
    final doc = await _collection.findOne({'_id': objectId});
    return doc != null ? Tecido.fromMap(doc) : null;
  }

  // GET: por id lógico (campo "id")
  Future<Tecido?> getPorIdTecido(int idTecido) async {
    final doc = await _collection.findOne({'id': idTecido});
    return doc != null ? Tecido.fromMap(doc) : null;
  }

  // GET: por grupo
  Future<List<Tecido>> getPorGrupo(int grupo) async {
    final docs = await _collection.find({'grupo': grupo}).toList();
    return docs.map((d) => Tecido.fromMap(d)).toList();
  }

  // Inserir
  Future<void> inserir(Tecido tecido) async {
    await _collection.insertOne(tecido.toMap());
  }

  // Atualizar por _id do Mongo
  Future<void> atualizar(String idMongo, Tecido tecido) async {
    final objectId = ObjectId.fromHexString(idMongo);
    await _collection.replaceOne({'_id': objectId}, tecido.toMap());
  }

  // Deletar
  Future<void> deletar(String idMongo) async {
    final objectId = ObjectId.fromHexString(idMongo);
    await _collection.deleteOne({'_id': objectId});
  }
}
