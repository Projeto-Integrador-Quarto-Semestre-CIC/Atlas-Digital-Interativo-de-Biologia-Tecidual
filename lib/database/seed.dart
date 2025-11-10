import 'package:mongo_dart/mongo_dart.dart';

import 'administrador.dart';
import 'professor.dart';
import 'tecido.dart';
import 'grupo_tecido.dart';

// URL do seu Mongo Atlas
const mongoUrl =
    'mongodb+srv://felipeduarteabc:3wPu9Wmv2KfptcM@cluster0.cthfqpb.mongodb.net/?appName=Cluster0';

Future<void> main() async {
  // Conectar no banco
  final db = await Db.create(mongoUrl);
  await db.open();
  print('✅ Conectado ao MongoDB para SEED');

  // Repositórios
  final admRepo = AdministradorRepository(db);
  final profRepo = ProfessorRepository(db);
  final grupoRepo = GrupoTecidoRepository(db);
  final tecidoRepo = TecidoRepository(db);

  // Limpar coleções antes de popular
  await db.collection('administradores').deleteMany({});
  await db.collection('professores').deleteMany({});
  await db.collection('grupotecidos').deleteMany({});
  await db.collection('tecidos').deleteMany({});
  print('🧹 Coleções limpas (administradores, professores, grupotecidos, tecidos)');

  // ======================
  // Administradores
  // ======================
  final admins = <Administrador>[
    Administrador(
      idAdministrador: 1,
      nome: 'admin',
      email: 'admin@teste.com',
      senha: 'admin123',
    ),
  ];

  for (final adm in admins) {
    await admRepo.inserir(adm);
  }
  print('✅ Administradores inseridos: ${admins.length}');

  // ======================
  // Professores
  // ======================
  final professores = <Professor>[
    Professor(
      idProfessor: 1,
      nome: 'duarte',
      email: 'duarte@teste.com',
      senha: 'duarte123',
    ),
  ];

  for (final prof in professores) {
    await profRepo.inserir(prof);
  }
  print('✅ Professores inseridos: ${professores.length}');

  // ======================
  // Grupos de Tecidos (grupoTecido)
  // ======================
    final grupos = <GrupoTecido>[
    GrupoTecido(
      idGrupo: 1,
      grupo: 'Tecido Epitelial',
      imagem: 'https://exemplo.com/img/epitelial.png',
    ),
    GrupoTecido(
      idGrupo: 2,
      grupo: 'Tecido Conjuntivo',
      imagem: 'https://exemplo.com/img/conjuntivo.png',
    ),
    GrupoTecido(
      idGrupo: 3,
      grupo: 'Tecido Muscular',
      imagem: 'https://exemplo.com/img/muscular.png',
    ),
    GrupoTecido(
      idGrupo: 4,
      grupo: 'Tecido Nervoso',
      imagem: 'https://exemplo.com/img/nervoso.png',
    ),
  ];

  for (final g in grupos) {
    await grupoRepo.inserir(g);
  }
  print('✅ Grupos de tecido inseridos: ${grupos.length}');

  // ======================
  // Tecidos (dentro dos grupos)
  // ======================
  final tecidos = <Tecido>[
    Tecido(
      idTecido: 1,
      grupo: 'Tecido Epitelial',
      tipo: 'Epitélio Simples Pavimentoso',
      nome: 'Tecido Epitelial Simples',
      texto: 'Epitélio formado por uma única camada de células achatadas.',
      imagem: 'https://exemplo.com/img/epi_simples_pavimentoso.png',
    ),
    Tecido(
      idTecido: 2,
      grupo: 'Tecido Epitelial',
      tipo: 'Epitélio Estratificado Pavimentoso',
      nome: 'Tecido Epitelial Estratificado',
      texto: 'Múltiplas camadas de células, com as mais superficiais achatadas.',
      imagem: 'https://exemplo.com/img/epi_estrat_pavimentoso.png',
    ),
    Tecido(
      idTecido: 3,
      grupo: 'Tecido Conjuntivo',
      tipo: 'Tecido Conjuntivo Frouxo',
      nome: 'Tecido Conjuntivo Frouxo',
      texto: 'Tecido com fibras pouco densas e bastante substância fundamental.',
      imagem: 'https://exemplo.com/img/conj_frouxo.png',
    ),
    Tecido(
      idTecido: 4,
      grupo: 'Tecido Muscular',
      tipo: 'Músculo Estriado Esquelético',
      nome: 'Tecido Muscular Estriado',
      texto: 'Responsável pelos movimentos voluntários do corpo.',
      imagem: 'https://exemplo.com/img/musc_estriado_esqueletico.png',
    ),
  ];

  for (final t in tecidos) {
    await tecidoRepo.inserir(t);
  }
  print('✅ Tecidos inseridos: ${tecidos.length}');

  // Fechar conexão
  await db.close();
  print('🏁 Seed finalizado');
}
