import 'package:flutter/material.dart';
import '../components/barra_lateral.dart';
import '../components/card_tipo_tecido.dart';
import '../components/botao_tecido.dart';
import '../services/tecidos_service.dart';

// IMPORTANTE: importar a página do tecido
import 'tecido.dart';

class PaginaGrupoTecido extends StatefulWidget {
  const PaginaGrupoTecido({super.key});

  @override
  State<PaginaGrupoTecido> createState() => _PaginaGrupoTecidoState();
}

class _PaginaGrupoTecidoState extends State<PaginaGrupoTecido> {
  late GrupoTecidoData _grupo;
  bool _inicializado = false;

  bool _carregando = true;
  String? _erro;

  // tipo -> lista de tecidos daquele tipo
  final Map<String, List<TecidoData>> _tecidosPorTipo = {};
  final List<String> _tipos = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is GrupoTecidoData) {
        _grupo = args;
      } else {
        _grupo = GrupoTecidoData(
          id: 0,
          grupo: 'Grupo desconhecido',
          imagem: '',
        );
      }
      _carregarTecidos();
      _inicializado = true;
    }
  }

  Future<void> _carregarTecidos() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      // busca TODOS os tecidos do grupo
      final tecidos =
          await TecidosService.listarTecidosPorGrupo(_grupo.grupo);

      _tecidosPorTipo.clear();

      for (final t in tecidos) {
        final lista = _tecidosPorTipo.putIfAbsent(t.tipo, () => []);
        lista.add(t);
      }

      _tipos
        ..clear()
        ..addAll(_tecidosPorTipo.keys.toList()..sort());

      setState(() {
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
        _erro = 'Erro ao carregar tecidos: $e';
      });
    }
  }

  Widget _buildGridTecidos(List<TecidoData> tecidos) {
    final isWide = MediaQuery.of(context).size.width >= 800;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: isWide ? 0.85 : 0.75,
      ),
      itemCount: tecidos.length,
      itemBuilder: (context, index) {
        final tecido = tecidos[index];
        print(
          'DEBUG: tecido id=${tecido.id} nome=${tecido.nome} tileSource="${tecido.tileSource}"',
        );

        final assetPath = tecido.imagemAssetPath;
        final imagePath = assetPath.isEmpty ? null : assetPath;

        return BotaoTecido(
          titulo: tecido.nome,
          imagePath: imagePath,
          corTitulo: Colors.black,
          onTap: () {
            // >>> AQUI montamos a navegação para PaginaTecido <<<
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaginaTecido(
                  nome: tecido.nome,
                  descricao: tecido.texto,
                  referenciasBibliograficas: tecido.referencias,
                  tileSource: tecido.tileSource,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool telaGrande = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFF4B5190),
      appBar: telaGrande
          ? null
          : AppBar(
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
                          child: const Icon(Icons.menu, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
              title: const Center(child: BotaoHome(sidebar: false)),
              centerTitle: true,
            ),
      drawer: telaGrande ? null : const SidebarDrawer(),
      body: Row(
        children: [
          if (telaGrande) const Sidebar(),
          Expanded(
            child: Center(
              child: FractionallySizedBox(
                widthFactor: telaGrande ? 0.85 : 0.95,
                heightFactor: telaGrande ? 0.85 : 0.92,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1500,
                    maxHeight: 900,
                    minWidth: 300,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // topo: voltar + nome do grupo
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.of(context).maybePop(),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF38853A),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _grupo.grupo.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 52),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // conteúdo
                        Expanded(
                          child: _carregando
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : _erro != null
                                  ? Center(
                                      child: Text(
                                        _erro!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : _tipos.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'Nenhum tecido cadastrado para este grupo.',
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              for (final tipo in _tipos) ...[
                                                CardTipoTecido(
                                                  titulo:
                                                      tipo.toUpperCase(),
                                                  expandedChild:
                                                      _buildGridTecidos(
                                                    _tecidosPorTipo[tipo] ??
                                                        [],
                                                  ),
                                                  initiallyExpanded: false,
                                                ),
                                                const SizedBox(height: 12),
                                              ],
                                            ],
                                          ),
                                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
