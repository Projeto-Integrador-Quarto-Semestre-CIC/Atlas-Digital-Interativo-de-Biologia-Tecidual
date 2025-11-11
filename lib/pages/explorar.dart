import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';
import 'package:app_pii/components/botao_tecido.dart';
import 'package:app_pii/services/tecidos_service.dart';

class PaginaExplorar extends StatefulWidget {
  const PaginaExplorar({super.key});

  @override
  State<PaginaExplorar> createState() => _PaginaExplorarState();
}

class _PaginaExplorarState extends State<PaginaExplorar> {
  final TextEditingController _searchController = TextEditingController();

  List<GrupoTecidoData> _todosGrupos = [];
  List<GrupoTecidoData> _gruposFiltrados = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarGrupos();
  }

  Future<void> _carregarGrupos() async {
    try {
      final grupos = await TecidosService.listarGrupos();
      setState(() {
        _todosGrupos = grupos;
        _gruposFiltrados = grupos;
        _carregando = false;
        _erro = null;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
        _erro = 'Erro ao carregar grupos: $e';
      });
    }
  }

  void _filtrar(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _gruposFiltrados = _todosGrupos;
      } else {
        _gruposFiltrados = _todosGrupos
            .where((g) => g.grupo.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double breakpoint = 900;
        final isNarrow = constraints.maxWidth < breakpoint;

        return Scaffold(
          backgroundColor: const Color(0xFF4B5190),
          drawer: isNarrow ? const SidebarDrawer() : null,
          appBar: isNarrow
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  toolbarHeight: 120,
                  leading: Builder(
                    builder: (context) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.white24,
                            child: Container(
                              width: 48,
                              height: 48,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF38853A),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  const Icon(Icons.menu, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  title: const Center(child: BotaoHome(sidebar: false)),
                  centerTitle: true,
                )
              : null,
          body: Row(
            children: [
              if (!isNarrow) const Sidebar(),
              Expanded(
                child: Column(
                  children: [
                    // Barra de busca
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: SearchBar(
                        controller: _searchController,
                        trailing: [
                          IconButton(
                            icon: const Icon(Icons.search,
                                color: Color(0xFF38853A)),
                            onPressed: () {
                              _filtrar(_searchController.text);
                            },
                          ),
                        ],
                        hintText: "Procure o tecido aqui!",
                        backgroundColor:
                            WidgetStateProperty.all(Colors.grey[200]),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onSubmitted: (query) {
                          _filtrar(query);
                        },
                      ),
                    ),

                    // Conteúdo: loading / erro / grid
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _carregando
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : _erro != null
                                ? Center(
                                    child: Text(
                                      _erro!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : _gruposFiltrados.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Nenhum grupo encontrado.',
                                          style:
                                              TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: isNarrow ? 2 : 5,
                                          mainAxisSpacing: 20.0,
                                          crossAxisSpacing: 20.0,
                                          childAspectRatio:
                                              isNarrow ? 0.85 : 0.75,
                                        ),
                                        itemCount: _gruposFiltrados.length,
                                        itemBuilder: (context, index) {
                                          final grupo =
                                              _gruposFiltrados[index];
                                          return BotaoTecido(
                                            titulo: grupo.grupo,
                                            imagePath: grupo.imagem,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/grupo_tecido',
                                                arguments: grupo,
                                              );
                                            },
                                          );
                                        },
                                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
