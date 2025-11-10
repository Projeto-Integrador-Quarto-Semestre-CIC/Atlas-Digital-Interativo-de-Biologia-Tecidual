import 'package:flutter/material.dart';

import 'package:app_pii/pages/tecido.dart';
import 'package:app_pii/pages/grupo_tecido.dart';
import 'package:app_pii/pages/login.dart';
import 'package:app_pii/pages/contato.dart';
import 'package:app_pii/pages/explorar.dart';
import 'package:app_pii/pages/home.dart';
import 'package:app_pii/pages/editar.dart';
import 'package:app_pii/pages/adicionar.dart';
import 'package:app_pii/pages/gerenciar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const HomePage(),
      routes: {
        '/login': (context) => const PaginaLogin(),
        '/contato': (context) => const PaginaContato(),
        '/explorar': (context) => const PaginaExplorar(),
        '/tecido': (context) => const PaginaTecido(
              nome: 'Tecido Teste',
              descricao: """Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.
Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.
""",
              referenciasBibliograficas: "Livro 1;\nLivro 2;\nWikipedia;\nSite 1;",
              tileSource: "http://localhost:8000/002_dzi/002.dzi"
            ),
        '/editar': (context) => const PaginaEditar(),
        '/adicionar': (context) => const PaginaAdicionar(),
        '/grupo_tecido': (context) => const PaginaGrupoTecido(),
        '/gerenciar': (context) => const GerenciarProfessoresPage()
      },
      
    );
  }
}