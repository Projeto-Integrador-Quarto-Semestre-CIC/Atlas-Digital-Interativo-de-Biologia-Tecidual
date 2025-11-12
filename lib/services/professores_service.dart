import 'dart:convert';
import 'package:http/http.dart' as http;

/// DTO para trabalhar com professores na UI
class ProfessorData {
  final int id;        // id lógico (ex: campo "id" no Mongo)
  final String nome;
  final String email;
  final String senha;  // em app real ideal seria hash/sem retorno, mas para seu PII tá ok

  ProfessorData({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  factory ProfessorData.fromMap(Map<String, dynamic> map) {
    return ProfessorData(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      nome: map['nome']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      senha: map['senha']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}

class ProfessoresService {
  /// Mesmo esquema dos outros services:
  /// - Web/desktop no mesmo PC:    http://localhost:3000
  /// - Emulador Android:           http://10.0.2.2:3000
  static const String _baseUrl = 'http://localhost:3000';

  // =============== LISTAR ===============
  static Future<List<ProfessorData>> listarProfessores() async {
    final resp = await http.get(Uri.parse('$_baseUrl/professores'));

    if (resp.statusCode != 200) {
      throw Exception(
        'Erro ao buscar professores: ${resp.statusCode} - ${resp.body}',
      );
    }

    final data = jsonDecode(resp.body) as List;
    return data
        .map((e) => ProfessorData.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // =============== CRIAR ===============
  static Future<ProfessorData> criarProfessor({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/professores'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception(
        'Erro ao criar professor: ${resp.statusCode} - ${resp.body}',
      );
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    // supondo que o backend devolve o professor criado
    return ProfessorData.fromMap(data);
  }

  // =============== ATUALIZAR ===============
  static Future<ProfessorData> atualizarProfessor(ProfessorData professor) async {
    final resp = await http.put(
      Uri.parse('$_baseUrl/professores/${professor.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': professor.nome,
        'email': professor.email,
        'senha': professor.senha,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception(
        'Erro ao atualizar professor: ${resp.statusCode} - ${resp.body}',
      );
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return ProfessorData.fromMap(data);
  }

  // =============== EXCLUIR ===============
  static Future<void> excluirProfessor(int id) async {
    final resp = await http.delete(
      Uri.parse('$_baseUrl/professores/$id'),
    );

    if (resp.statusCode != 200) {
      throw Exception(
        'Erro ao excluir professor: ${resp.statusCode} - ${resp.body}',
      );
    }
  }
}
