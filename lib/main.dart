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
import 'package:app_pii/services/tecidos_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const HomePage(),
      onGenerateRoute: (settings) {
        // rota tecido: aceita TecidoData (passado pelo app) ou int id (busca do backend)
        if (settings.name == '/tecido') {
          final args = settings.arguments;
          if (args is TecidoData) {
            return MaterialPageRoute(
              builder: (_) => PaginaTecido(
                nome: args.nome,
                descricao: args.texto,
                referencias: args.referencias,
                tileSource: args.tileSource.isNotEmpty ? TecidosService.urlFromRelative(args.tileSource) : '',
              ),
            );
          }
          if (args is int) {
            return MaterialPageRoute(builder: (_) => _TecidoLoaderPage(id: args));
          }
          // sem args -> erro simples
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Tecido não informado'))));
        }

        // rotas estáticas restantes
        final routes = <String, WidgetBuilder>{
          '/login': (context) => const PaginaLogin(),
          '/contato': (context) => const PaginaContato(),
          '/explorar': (context) => const PaginaExplorar(),
          '/editar': (context) => const PaginaEditar(),
          '/adicionar': (context) => const PaginaAdicionar(),
          '/grupo_tecido': (context) => const PaginaGrupoTecido(),
          '/gerenciar': (context) => const GerenciarProfessoresPage(),
        };
        final builder = routes[settings.name];
        if (builder != null) return MaterialPageRoute(builder: builder, settings: settings);
        return null;
      },
    );
  }
}

// Loader page que busca o tecido do backend antes de abrir PaginaTecido
class _TecidoLoaderPage extends StatelessWidget {
  final int id;
  const _TecidoLoaderPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TecidoData?>(
      future: TecidosService.getTecidoById(id),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!snap.hasData || snap.data == null) {
          return Scaffold(body: Center(child: Text('Não foi possível carregar o tecido.')));
        }
        final t = snap.data!;
        return PaginaTecido(
          nome: t.nome,
          descricao: t.texto,
          referencias: t.referencias,
          tileSource: t.tileSource.isNotEmpty ? TecidosService.urlFromRelative(t.tileSource) : '',
        );
      },
    );
  }
}