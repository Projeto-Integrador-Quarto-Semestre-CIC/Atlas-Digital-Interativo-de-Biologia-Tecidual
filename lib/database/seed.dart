import 'package:mongo_dart/mongo_dart.dart';

import 'administrador.dart';
import 'professor.dart';

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

  // Limpar coleções antes de popular
  await db.collection('administradores').deleteMany({});
  await db.collection('professores').deleteMany({});
  print('🧹 Coleções administradores e professores limpas');

  // Dados de administradores
  final admins = <Administrador>[
    Administrador(
      idAdministrador: 2,
      nome: 'admin2',           // aqui é o USUÁRIO de login
      email: 'admin2@teste.com',
      senha: 'admin123',
    ),
  ];

  // Dados de professores
  final professores = <Professor>[
    Professor(
      idProfessor: 1,
      nome: 'duarte2',           // aqui é o USUÁRIO de login
      email: 'duarte2@teste.com',
      senha: 'duarte123',
    ),
  ];

  // Inserir administradores
  for (final adm in admins) {
    await admRepo.inserir(adm);
  }
  print('✅ Administradores inseridos: ${admins.length}');

  // Inserir professores
  for (final prof in professores) {
    await profRepo.inserir(prof);
  }
  print('✅ Professores inseridos: ${professores.length}');

  // Fechar conexão
  await db.close();
  print('🏁 Seed finalizado');
}
