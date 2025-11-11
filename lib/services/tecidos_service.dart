import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// DTO simples pra trabalhar com grupos na UI
class GrupoTecidoData {
  final int id;
  final String grupo;
  final String imagem; // caminho bruto vindo do backend (ex: "/grupos/arquivo.png" ou "")

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

  /// URL final da imagem para usar no Flutter.
  /// - Se já for URL completa (http/https), retorna como está.
  /// - Se for caminho relativo ("/grupos/arquivo.png"), prefixa com a base da API.
  String get imagemUrl {
    if (imagem.isEmpty) return '';

    // já é URL completa
    if (imagem.startsWith('http://') || imagem.startsWith('https://')) {
      return imagem;
    }

    // normaliza barras
    var path = imagem.replaceAll('\\', '/');

    // garante que começa com "/"
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    // codifica espaços e caracteres especiais no caminho
    final encodedPath = Uri.encodeFull(path);

    return '${TecidosService.apiBaseUrl}$encodedPath';
  }
}

class TecidosService {
  /// URL base da API.
  ///
  /// ⚠️ IMPORTANTE:
  /// - Se for Flutter Web / Desktop rodando no mesmo PC:  'http://localhost:3000'
  /// - Se for emulador Android:                          'http://10.0.2.2:3000'
  /// - Se for celular físico:                            'http://IP_DA_SUA_MAQUINA:3000'
  static const String apiBaseUrl = 'http://localhost:3000';

  static const String _baseUrl = apiBaseUrl;

  // ============================================================
  // GRUPOS
  // ============================================================

  /// Lista todos os grupos de tecido.
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

  /// Alias para manter compatibilidade com código antigo (se você usava buscarGrupos).
  static Future<List<GrupoTecidoData>> buscarGrupos() {
    return listarGrupos();
  }

  /// Cria um novo grupo de tecido.
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
    return data['ok'] == true;
  }

  // ============================================================
  // TIPOS
  // ============================================================

  /// Busca todos os tecidos de um grupo e devolve os TIPOS distintos.
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

  // ============================================================
  // UPLOAD DE IMAGENS
  // ============================================================

  /// Faz upload da imagem de TECIDO e retorna o caminho salvo no backend
  /// (ex.: "/grupos/arquivo.png") ou null em caso de erro.
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

  /// Faz upload da imagem de GRUPO e retorna o caminho salvo no backend
  /// (ex.: "/grupos/arquivo.png") ou null em caso de erro.
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

  // ============================================================
  // TECIDOS
  // ============================================================

  /// Cria um novo tecido.
  static Future<bool> criarTecido({
    required String grupo,
    required String tipo,
    required String nome,
    required String texto,
    String imagem = '',
  }) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/tecidos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'grupo': grupo,
        'tipo': tipo,
        'nome': nome,
        'texto': texto,
        'imagem': imagem,
      }),
    );

    if (resp.statusCode != 200) {
      print('Erro ao criar tecido: ${resp.statusCode} - ${resp.body}');
      return false;
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return data['ok'] == true;
  }
}
