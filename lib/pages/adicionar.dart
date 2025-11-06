import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';

class PaginaAdicionar extends StatefulWidget {
  const PaginaAdicionar({super.key});

  @override
  State<PaginaAdicionar> createState() => _PaginaAdicionarState();
}

class _PaginaAdicionarState extends State<PaginaAdicionar> {
  final TextEditingController nomeTecidoController = TextEditingController();
  final TextEditingController descTecidoController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? grupoSelecionado;

  // Corrige erro: tecidosPorGrupo indefinido
  final Map<String, List<Map<String, String>>> tecidosPorGrupo = {};
  final List<String> grupos = [
    'Grupo 1',
    'Grupo 2',
    'Grupo 3',
  ];

                                    // grupos (full width)                                      

  @override
  void dispose() {
    nomeTecidoController.dispose();
    descTecidoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _mostrarDialogoNovoGrupo() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Grupo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nome do grupo',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final nome = controller.text.trim();
              if (nome.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Digite um nome para o grupo')),
                );
                return;
              }
              if (grupos.contains(nome)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Grupo já existe')),
                );
                return;
              }
              Navigator.pop(context, nome);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        grupos.add(result);
        grupoSelecionado = result; // Seleciona o novo grupo automaticamente
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grupo adicionado')),
      );
    }
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
    list.add({
      'nome': nome,
      'descricao': descTecidoController.text.trim(),
    });
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
                  backgroundColor: const Color.fromARGB(0, 170, 2, 2),
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
                )
              : null,
          body: Row(
            children: [
              if (!isNarrow) const Sidebar(),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFF2FA14A),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 8,
                        radius: const Radius.circular(4),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                                    onPressed: () => Navigator.pop(context),
                                    splashRadius: 24,
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 16),

                          isNarrow
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // grupos (full width)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          const Text('Selecione o grupo:', 
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2D2D2D)
                                            )
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50],
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(color: Colors.grey[300]!),
                                            ),
                                            child: DropdownButton<String>(
                                              value: grupoSelecionado,
                                              isExpanded: true,
                                              hint: const Text('Selecione um grupo'),                                      
                                              underline: Container(),
                                              items: [
                                                ...grupos.map((g) => DropdownMenuItem(
                                                  value: g,
                                                  child: Text(g),
                                                )),
                                                const DropdownMenuItem(
                                                  value: 'novo',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.add, color: Color(0xFF2FA14A)),
                                                      SizedBox(width: 8),
                                                      Text('Criar novo grupo'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                if (value == 'novo') {
                                                  _mostrarDialogoNovoGrupo();
                                                } else {
                                                  setState(() => grupoSelecionado = value);
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // nome do tecido
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

                                    // descricao do tecido
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                        const Text('Adicione a descrição do tecido:'),                                      
                                        const SizedBox(height: 8),
                                        TextField(controller: descTecidoController, maxLines: 6, decoration: const InputDecoration(border: InputBorder.none, isDense: true)),
                                      ]),
                                    ),
                                    const SizedBox(height: 12),

                                    // imagem
                                    Center(
                                      child: Container(
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
                                    ),

                                    // botoes em linha
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _adicionarTecido();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.greenAccent.shade700,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              minimumSize: const Size.fromHeight(50),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text(
                                              'Confirmar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              nomeTecidoController.clear();
                                              descTecidoController.clear();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              minimumSize: const Size.fromHeight(50),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Lista de grupos 
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            const Text('Selecione o grupo:', style: TextStyle(fontSize: 16)),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8F8F8),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: DropdownButton<String>(
                                                value: grupoSelecionado,
                                                isExpanded: true,
                                                hint: const Text('Selecione um grupo'),
                                                underline: Container(),
                                                items: [
                                                  ...grupos.map((g) => DropdownMenuItem(
                                                    value: g,
                                                    child: Text(g),
                                                  )),
                                                  const DropdownMenuItem(
                                                    value: 'novo',
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.add, color: Color(0xFF2FA14A)),
                                                        SizedBox(width: 8),
                                                        Text('Criar novo grupo'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                                onChanged: (value) {
                                                  if (value == 'novo') {
                                                    _mostrarDialogoNovoGrupo();
                                                  } else {
                                                    setState(() => grupoSelecionado = value);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    //adicionar tecido
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

                                    // coluna de ações / imagem 
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
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.greenAccent.shade700,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              minimumSize: const Size.fromHeight(50),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text(
                                              'Confirmar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          ElevatedButton(
                                            onPressed: () {
                                              // limpar campos
                                              nomeTecidoController.clear();
                                              descTecidoController.clear();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              minimumSize: const Size.fromHeight(50),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
