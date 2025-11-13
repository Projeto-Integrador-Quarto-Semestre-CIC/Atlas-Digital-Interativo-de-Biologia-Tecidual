import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// DTO simples pra trabalhar com grupos na UI
class GrupoTecidoData {
  final int id;
  final String grupo;
  final String imagem;

  GrupoTecidoData({
    required this.id,
    required this.grupo,
    required this.imagem,
  });

  factory GrupoTecidoData.fromMap(Map<String, dynamic> map) {
    return GrupoTecidoData(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      grupo: map['grupo']?.toString() ?? '',
      imagem: map['imagem']?.toString() ?? '',
    );
  }
  String get imagemUrl {
    if (imagem.isEmpty) return '';
    return TecidosService.urlFromRelative(imagem);
  }
  /// Caminho de asset para a imagem do GRUPO (se você estiver usando assets).
  String get imagemAssetPath {
    if (imagem.isEmpty) return '';
    var path = imagem.replaceAll('\\', '/');
    final fileName = path.split('/').last;
    return 'uploads/grupos/$fileName';
  }
}

/// DTO pra trabalhar com TECIDOS na UI
class TecidoData {
  final int id;
  final String grupo;
  final String tipo;
  final String nome;
  final String texto;
  final String imagem;
  final String tileSource;

  TecidoData({
    required this.id,
    required this.grupo,
    required this.tipo,
    required this.nome,
    required this.texto,
    required this.imagem,
    this.tileSource = '',
  });

  String get imagemUrl {
    if (imagem.isEmpty) return '';
    return TecidosService.urlFromRelative(imagem);
  }

  factory TecidoData.fromMap(Map<String, dynamic> map) {
    return TecidoData(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      grupo: map['grupo']?.toString() ?? '',
      tipo: map['tipo']?.toString() ?? '',
      nome: map['nome']?.toString() ?? '',
      texto: map['texto']?.toString() ?? '',
      imagem: map['imagem']?.toString() ?? '',
     tileSource: map['tileSource']?.toString() ?? '',
    );
  }

  /// Caminho de asset para a imagem do TECIDO (se estiver usando assets).
  String get imagemAssetPath {
    if (imagem.isEmpty) return '';
    var path = imagem.replaceAll('\\', '/');
    final fileName = path.split('/').last;
    return 'uploads/tecidos/$fileName';
  }
}

class TecidosService {
  // Base do backend (usar apenas um lugar)
  static const String apiBaseUrl = 'http://localhost:3000';
  static const String _baseUrl = apiBaseUrl;

  // Pedir ao servidor para converter um .mrxs local acessível ao servidor
  static Future<String?> convertSlideFromLocalPath(String localPath) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/upload_slide'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'localPath': localPath}),
    );
    if (resp.statusCode != 200) {
      print('convertSlideFromLocalPath falhou: ${resp.statusCode} - ${resp.body}');
      return null;
    }
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (data['ok'] == true && data['dzi'] != null) return data['dzi'].toString();
    return null;
  }

  static String urlFromRelative(String path) {
    // normaliza barras para evitar '//'
    var normalized = path.replaceAll('\\', '/');
    while (normalized.startsWith('/')) normalized = normalized.substring(1);
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '$apiBaseUrl/$normalized?ts=$ts'; // cache-buster
  }

  // ================== GRUPOS ==================

  static Future<List<GrupoTecidoData>> listarGrupos() async {
    final resp = await http.get(Uri.parse('$_baseUrl/grupos'));

    if (resp.statusCode != 200) {
      throw Exception(
        'Erro ao buscar grupos: ${resp.statusCode} - ${resp.body}',
      );
    }

    final data = jsonDecode(resp.body) as List;
    return data
        .map((e) => GrupoTecidoData.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<GrupoTecidoData>> buscarGrupos() {
    return listarGrupos();
  }

  static Future<bool> criarGrupo({
    required String grupo,
    required String imagem,
  }) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/grupos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'grupo': grupo,
        'imagem': imagem,
      }),
    );

    if (resp.statusCode != 200) {
      print('Erro ao criar grupo: ${resp.statusCode} - ${resp.body}');
      return false;
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return data['ok'] == true; // espera { ok: true, grupo: {...} }
  }

  // ================== TIPOS ==================

  /// devolve apenas os nomes dos tipos de um grupo
  static Future<List<String>> listarTiposPorGrupo(String grupo) async {
    final resp =
        await http.get(Uri.parse('$_baseUrl/tecidos?grupo=$grupo'));

    if (resp.statusCode != 200) {
      print('Erro ao buscar tipos: ${resp.statusCode} - ${resp.body}');
      return [];
    }

    final data = jsonDecode(resp.body) as List;
    final setTipos = <String>{};

    for (final item in data) {
      final map = item as Map<String, dynamic>;
      final tipo = map['tipo']?.toString();
      if (tipo != null && tipo.isNotEmpty) {
        setTipos.add(tipo);
      }
    }

    return setTipos.toList();
  }

  /// BUSCA TODOS os TECIDOS de um grupo.
  static Future<List<TecidoData>> listarTecidosPorGrupo(
      String grupo) async {
    final resp =
        await http.get(Uri.parse('$_baseUrl/tecidos?grupo=$grupo'));

    if (resp.statusCode != 200) {
      throw Exception(
        'Erro ao buscar tecidos: ${resp.statusCode} - ${resp.body}',
      );
    }

    final data = jsonDecode(resp.body) as List;
    return data
        .map((e) => TecidoData.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ================== UPLOAD IMAGENS ==================

  static Future<String?> uploadImagemTecido({
    required String nomeArquivo,
    required Uint8List bytes,
  }) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/upload_imagem_tecido'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nomeArquivo,
        'bytes': base64Encode(bytes),
      }),
    );

    if (resp.statusCode != 200) {
      print('Erro upload imagem tecido: ${resp.statusCode} - ${resp.body}');
      return null;
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (data['ok'] == true) {
      return data['path']?.toString();
    }
    return null;
  }

  static Future<String?> uploadImagemGrupo({
    required String nomeArquivo,
    required Uint8List bytes,
  }) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/upload_imagem_grupo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nomeArquivo,
        'bytes': base64Encode(bytes),
      }),
    );

    if (resp.statusCode != 200) {
      print('Erro upload imagem grupo: ${resp.statusCode} - ${resp.body}');
      return null;
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (data['ok'] == true) {
      return data['path']?.toString();
    }
    return null;
  }

  // ================== UPLOAD E CONVERSÃO DO SLIDE (.mrxs para .dzi) ==================
  static Future<String?> uploadSlide({
    required String nomeArquivo,
    required Uint8List bytes,
  }) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/upload_slide'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nomeArquivo,
        'bytes': base64Encode(bytes),
      }),
    );

    if (resp.statusCode != 200) {
      print('Erro upload slide: ${resp.statusCode} - ${resp.body}');
      return null;
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (data['ok'] == true && data['dzi'] != null) {
      return data['dzi'].toString(); // caminho onde o slide foi salvo
    }
    return null;
  }

  // ================== TECIDOS ==================

  static Future<bool> criarTecido({
    required String grupo,
    required String tipo,
    required String nome,
    required String texto,
    String imagem = '',
    String tileSource = '',
  }) async {
    final payload = {
      'grupo': grupo,
      'tipo': tipo,
      'nome': nome,
      'texto': texto,
      'imagem': imagem,
      'tileSource': tileSource,
    };
    // DEBUG: ver payload antes do POST
    print('TecidosService.criarTecido payload: ${jsonEncode(payload)}');

    final resp = await http.post(
      Uri.parse('$_baseUrl/tecidos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (resp.statusCode != 200) {
      print('Erro ao criar tecido: ${resp.statusCode} - ${resp.body}');
      return false;
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return data['ok'] == true;
  }


  // GRUPOS
static Future<void> excluirGrupo(int idGrupo) async {
  final resp = await http.delete(Uri.parse('$_baseUrl/grupos/$idGrupo'));
  if (resp.statusCode != 200) {
    throw Exception('Erro ao excluir grupo: ${resp.statusCode} - ${resp.body}');
  }
}

static Future<void> atualizarGrupo(GrupoTecidoData grupo) async {
  final resp = await http.put(
    Uri.parse('$_baseUrl/grupos/${grupo.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'grupo': grupo.grupo, 'imagem': grupo.imagem}),
  );
  if (resp.statusCode != 200) {
    throw Exception('Erro ao atualizar grupo: ${resp.statusCode} - ${resp.body}');
  }
}

// TECIDOS
static Future<void> excluirTecido(int idTecido) async {
  final resp = await http.delete(Uri.parse('$_baseUrl/tecidos/$idTecido'));
  if (resp.statusCode != 200) {
    throw Exception('Erro ao excluir tecido: ${resp.statusCode} - ${resp.body}');
  }
}

static Future<TecidoData> atualizarTecido(TecidoData t) async {
  final resp = await http.put(
    Uri.parse('$_baseUrl/tecidos/${t.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'grupo': t.grupo,
      'tipo': t.tipo,
      'nome': t.nome,
      'texto': t.texto,
      'imagem': t.imagem,
    }),
  );
  if (resp.statusCode != 200) {
    throw Exception('Erro ao atualizar tecido: ${resp.statusCode} - ${resp.body}');
  }
  final data = jsonDecode(resp.body) as Map<String, dynamic>;
  return TecidoData.fromMap(data);
}

  static Future<TecidoData?> getTecidoById(int id) async {
    final resp = await http.get(Uri.parse('$_baseUrl/tecidos/$id'));
    if (resp.statusCode != 200) {
      print('Erro ao buscar tecido $id: ${resp.statusCode} - ${resp.body}');
      return null;
    }
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return TecidoData.fromMap(data);
  }
}
