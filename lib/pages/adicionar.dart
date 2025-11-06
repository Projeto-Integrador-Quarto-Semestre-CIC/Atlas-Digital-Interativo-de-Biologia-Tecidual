import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';

class PaginaAdicionar extends StatefulWidget {
  const PaginaAdicionar({super.key});

  @override
  State<PaginaAdicionar> createState() => _PaginaAdicionarState();
}

class _PaginaAdicionarState extends State<PaginaAdicionar> {
  final TextEditingController grupoNovoController = TextEditingController();
  final TextEditingController nomeTecidoController = TextEditingController();
  final TextEditingController descTecidoController = TextEditingController();
  String? grupoSelecionado;

  final List<String> grupos = [
    'Grupo 1',
    'Grupo 2',
    'Grupo 3',
  ];

  final Map<String, List<String>> tecidosPorGrupo = {};

  @override
  void dispose() {
    grupoNovoController.dispose();
    nomeTecidoController.dispose();
    descTecidoController.dispose();
    super.dispose();
  }

  void _adicionarGrupo() {
    final nome = grupoNovoController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Digite um nome para o grupo')));
      return;
    }
    if (grupos.contains(nome)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grupo já existe')));
      return;
    }
    setState(() {
      grupos.add(nome);
      grupoNovoController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grupo adicionado (simulado)')));
  }

  void _adicionarTecido() {
    final nome = nomeTecidoController.text.trim();
    if (grupoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um grupo antes de adicionar tecido')));
      return;
    }
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Digite o nome do tecido')));
      return;
    }
    final list = tecidosPorGrupo.putIfAbsent(grupoSelecionado!, () => []);
    list.add(nome);
    nomeTecidoController.clear();
    descTecidoController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tecido adicionado (simulado)')));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        return Scaffold(
          backgroundColor: const Color(0xFF4B5190),
          drawer: isNarrow ? const SidebarDrawer() : null,
          appBar: isNarrow
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  toolbarHeight: 120,
                  title: const Center(child: Text('Adicionar', style: TextStyle(color: Colors.white))),
                )
              : null,
          body: Row(
            children: [
              if (!isNarrow) const Sidebar(),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: const Color(0xFF2FA14A), borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          const Center(
                            child: Text('Adicionar Grupos e Tecidos', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 20),

                          // Left column-like layout using rows
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Lista de grupos (coluna esquerda)
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Text('Selecione o grupo:'),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 260,
                                        child: ListView.separated(
                                          itemCount: grupos.length,
                                          separatorBuilder: (_, __) => Divider(color: Colors.green[700]),
                                          itemBuilder: (context, index) {
                                            final g = grupos[index];
                                            return ListTile(
                                              title: Text(g, style: TextStyle(color: g == grupoSelecionado ? Colors.white : Colors.green[700])),
                                              tileColor: g == grupoSelecionado ? Colors.green[700] : null,
                                              onTap: () => setState(() => grupoSelecionado = g),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: grupoNovoController,
                                              decoration: const InputDecoration(hintText: 'Novo Grupo', filled: true, fillColor: Color(0xFFF8F8F8)),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: _adicionarGrupo,
                                            child: const Icon(Icons.add),
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Form para adicionar tecido (direita)
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                        const Text('Adicione o nome do tecido:'),
                                        const SizedBox(height: 8),
                                        TextField(controller: nomeTecidoController, decoration: const InputDecoration(border: InputBorder.none, isDense: true)),
                                      ]),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                        const Text('Adicione a descrição do tecido:'),
                                        const SizedBox(height: 8),
                                        TextField(controller: descTecidoController, maxLines: 6, decoration: const InputDecoration(border: InputBorder.none, isDense: true)),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              // coluna de ações / imagem (direita lateral)
                              SizedBox(
                                width: 140,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      child: IconButton(
                                        iconSize: 48,
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inserir imagem (simulado)')));
                                        },
                                        icon: const Icon(Icons.file_upload_outlined),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _adicionarTecido();
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent.shade700, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                      child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        // limpar campos
                                        nomeTecidoController.clear();
                                        descTecidoController.clear();
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                      child: const Text('Cancelar'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
