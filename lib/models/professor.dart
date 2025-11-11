import 'package:mongo_dart/mongo_dart.dart';

/// ========================
///  MODEL: Professor
/// ========================
class Professor {
  ObjectId? _id;
  int _idProfessor;
  String _nome;
  String _email;
  String _senha;

  Professor({
    ObjectId? id,
    required int idProfessor,
    required String nome,
    required String email,
    required String senha,
  })  : _id = id,
        _idProfessor = idProfessor,
        _nome = nome,
        _email = email,
        _senha = senha;

  // === GETTERS ===
  ObjectId? get id => _id;
  int get idProfessor => _idProfessor;
  String get nome => _nome;
  String get email => _email;
  String get senha => _senha;

  // === SETTERS (opcionais) ===
  set nome(String novoNome) => _nome = novoNome;
  set email(String novoEmail) => _email = novoEmail;
  set senha(String novaSenha) => _senha = novaSenha;

  // === Converte documento Mongo -> Dart ===
  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      id: map['_id'] as ObjectId?,
      idProfessor: map['idProfessor'] is int
          ? map['idProfessor']
          : int.parse(map['idProfessor'].toString()),
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }

  // === Converte Dart -> Mongo ===
  Map<String, dynamic> toMap() {
    return {
      if (_id != null) '_id': _id,
      'idProfessor': _idProfessor,
      'nome': _nome,
      'email': _email,
      'senha': _senha,
    };
  }
}

/// ========================
///  REPOSITORY: Acesso MongoDB
/// ========================
class ProfessorRepository {
  final Db _db;
  late final DbCollection _collection;

  ProfessorRepository(this._db) {
    _collection = _db.collection('professores');
  }

  // GET: todos os professores
  Future<List<Professor>> getTodos() async {
    final docs = await _collection.find().toList();
    return docs.map((doc) => Professor.fromMap(doc)).toList();
  }

  // GET: por ID
  Future<Professor?> getPorId(String id) async {
    final objectId = ObjectId.fromHexString(id);
    final doc = await _collection.findOne({'_id': objectId});
    return doc != null ? Professor.fromMap(doc) : null;
  }

  // GET: por e-mail
  Future<Professor?> getPorEmail(String email) async {
    final doc = await _collection.findOne({'email': email});
    return doc != null ? Professor.fromMap(doc) : null;
  }

  Future<Professor?> getPorNome(String nome) async {
  final doc = await _collection.findOne({'nome': nome});
  return doc != null ? Professor.fromMap(doc) : null;
}
  // Inserir novo professor
  Future<void> inserir(Professor professor) async {
    await _collection.insertOne(professor.toMap());
  }

  // Atualizar professor
  Future<void> atualizar(String id, Professor professor) async {
    final objectId = ObjectId.fromHexString(id);
    await _collection.replaceOne({'_id': objectId}, professor.toMap());
  }

  // Deletar professor
  Future<void> deletar(String id) async {
    final objectId = ObjectId.fromHexString(id);
    await _collection.deleteOne({'_id': objectId});
  }
}


