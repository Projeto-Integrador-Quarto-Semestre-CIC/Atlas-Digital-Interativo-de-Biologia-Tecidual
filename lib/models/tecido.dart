import 'package:mongo_dart/mongo_dart.dart';

/// ========================
///  MODEL: Tecido
/// ========================
class Tecido {
  final ObjectId? idMongo;
  final int idTecido;
  final String grupo;
  final String tipo;
  final String nome;
  final String texto;
  final String imagem;
  final String tileSource;
  final String referencias; // <-- NOVO CAMPO

  Tecido({
    this.idMongo,
    required this.idTecido,
    required this.grupo,
    required this.tipo,
    required this.nome,
    required this.texto,
    required this.imagem,
    this.tileSource = '',
    this.referencias = '', // <-- default para não quebrar dados antigos
  });

  Map<String, dynamic> toMap() {
    return {
      if (idMongo != null) '_id': idMongo,
      'id': idTecido,
      'grupo': grupo,
      'tipo': tipo,
      'nome': nome,
      'texto': texto,
      'imagem': imagem,
      'tileSource': tileSource,
      'referencias': referencias, // <-- adicionado ao map
    };
  }

  factory Tecido.fromMap(Map<String, dynamic> map) {
    ObjectId? idMongo;
    final rawId = map['_id'];

    if (rawId != null) {
      if (rawId is ObjectId) {
        idMongo = rawId;
      } else if (rawId is String) {
        try {
          idMongo = ObjectId.fromHexString(rawId);
        } catch (_) {
          final hexMatch = RegExp(r'([0-9a-fA-F]{24})').firstMatch(rawId);
          if (hexMatch != null) {
            try {
              idMongo = ObjectId.fromHexString(hexMatch.group(0)!);
            } catch (_) {}
          }
        }
      } else if (rawId is Map && rawId.containsKey(r'$oid')) {
        try {
          idMongo = ObjectId.fromHexString(rawId[r'$oid'].toString());
        } catch (_) {}
      }
    }

    return Tecido(
      idMongo: idMongo,
      idTecido: map['id'] is int ? map['id'] as int : int.tryParse(map['id']?.toString() ?? '') ?? 0,
      grupo: map['grupo']?.toString() ?? '',
      tipo: map['tipo']?.toString() ?? '',
      nome: map['nome']?.toString() ?? '',
      texto: map['texto']?.toString() ?? '',
      imagem: map['imagem']?.toString() ?? '',
      tileSource: map['tileSource']?.toString() ?? '',
      referencias: map['referencias']?.toString() ?? '', // <-- leitura segura
    );
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

  // GET: por grupo (string)
  Future<List<Tecido>> getPorGrupo(String grupo) async {
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
