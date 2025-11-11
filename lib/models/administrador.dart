import 'package:mongo_dart/mongo_dart.dart';

/// ========================
///  MODEL: Administrador
/// ========================
class Administrador {
  ObjectId? _id;
  int _idAdministrador;
  String _nome;
  String _email;
  String _senha;

  Administrador({
    ObjectId? id,
    required int idAdministrador,
    required String nome,
    required String email,
    required String senha,
  })  : _id = id,
        _idAdministrador = idAdministrador,
        _nome = nome,
        _email = email,
        _senha = senha;

  // GETTERS
  ObjectId? get id => _id;
  int get idAdministrador => _idAdministrador;
  String get nome => _nome;
  String get email => _email;
  String get senha => _senha;

  // SETTERS (opcionais)
  set nome(String v) => _nome = v;
  set email(String v) => _email = v;
  set senha(String v) => _senha = v;

  // Mongo -> Dart
  factory Administrador.fromMap(Map<String, dynamic> map) {
    return Administrador(
      id: map['_id'] as ObjectId?,
      idAdministrador: map['idAdministrador'] is int
          ? map['idAdministrador']
          : int.parse(map['idAdministrador'].toString()),
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }

  // Dart -> Mongo
  Map<String, dynamic> toMap() {
    return {
      if (_id != null) '_id': _id,
      'idAdministrador': _idAdministrador,
      'nome': _nome,
      'email': _email,
      'senha': _senha,
    };
  }
}

/// ========================
///  REPOSITORY: Administrador
/// ========================
class AdministradorRepository {
  final Db _db;
  late final DbCollection _collection;

  AdministradorRepository(this._db) {
    _collection = _db.collection('administradores');
  }

  Future<List<Administrador>> getTodos() async {
    final docs = await _collection.find().toList();
    return docs.map((d) => Administrador.fromMap(d)).toList();
  }

  Future<Administrador?> getPorId(String id) async {
    final objectId = ObjectId.fromHexString(id);
    final doc = await _collection.findOne({'_id': objectId});
    return doc != null ? Administrador.fromMap(doc) : null;
  }

  Future<Administrador?> getPorNome(String nome) async {
  final doc = await _collection.findOne({'nome': nome});
  return doc != null ? Administrador.fromMap(doc) : null;
  }
  Future<Administrador?> getPorEmail(String email) async {
    final doc = await _collection.findOne({'email': email});
    return doc != null ? Administrador.fromMap(doc) : null;
  }

  Future<void> inserir(Administrador adm) async {
    await _collection.insertOne(adm.toMap());
  }

  Future<void> atualizar(String id, Administrador adm) async {
    final objectId = ObjectId.fromHexString(id);
    await _collection.replaceOne({'_id': objectId}, adm.toMap());
  }

  Future<void> deletar(String id) async {
    final objectId = ObjectId.fromHexString(id);
    await _collection.deleteOne({'_id': objectId});
  }
}
