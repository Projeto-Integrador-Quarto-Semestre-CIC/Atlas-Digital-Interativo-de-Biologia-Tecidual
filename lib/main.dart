import 'package:app_pii/pages/tecido.dart';
import 'package:flutter/material.dart';
import 'package:app_pii/pages/login.dart';
import 'package:app_pii/pages/contato.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/login': (context) => const TelaLogin(),
        '/contato': (context) => const PaginaContato(),
      },
      home: const TelaTecido(
        nome: 'Tecido Teste',
        descricao: """Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.
Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.
""",
        referenciasBibliograficas: "Livro 1;\nLivro 2;\nWikipedia;\nSite 1;",
        tileSource: "http://localhost:8000/002_dzi/002.dzi"
      ),
    );
  }
}