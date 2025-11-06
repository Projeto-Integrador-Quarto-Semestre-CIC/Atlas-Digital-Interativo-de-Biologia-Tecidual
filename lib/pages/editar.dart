import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';

class PaginaEditar extends StatefulWidget {
  const PaginaEditar({super.key});

  @override
  State<PaginaEditar> createState() => _PaginaEditarState();
}

class _PaginaEditarState extends State<PaginaEditar> {
  String? grupoSelecionado;
  final List<String> grupos = [
    'Grupo 1',
    'Grupo 2',
    'Grupo 3',
    'Grupo 4',
    'Grupo 5',
    'Grupo 6',
  ];

  int passo = 1;
 
  final List<String> tecidos = ['Tecido 1', 'Tecido 2', 'Tecido 3'];
  String? tecidoSelecionado;

  late TextEditingController grupoController;
  late TextEditingController tecidoController;
  late TextEditingController descricaoController;

  late ScrollController _scrollController;

  void _selecionarGrupo(String grupo) {
    setState(() {
      grupoSelecionado = grupo;
    });
  }

  @override
  void initState() {
    super.initState();
    grupoController = TextEditingController();
    tecidoController = TextEditingController();
    descricaoController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    grupoController.dispose();
    tecidoController.dispose();
    descricaoController.dispose();
    _scrollController.dispose();
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
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2FA14A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (passo == 1)
                              const Text(
                                'Selecione o grupo que deseja editar:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            const SizedBox(height: 40),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 900),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: passo == 1
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        ...grupos.map((grupo) => Container(
                                              margin: const EdgeInsets.only(bottom: 1),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.green[700]!,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () => _selecionarGrupo(grupo),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 8,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: grupoSelecionado == grupo
                                                          ? Colors.green[50]
                                                          : Colors.transparent,
                                                    ),
                                                    child: Text(
                                                      grupo,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.green[700],
                                                        fontWeight: grupoSelecionado == grupo
                                                            ? FontWeight.w600
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )).toList(),
                                        const SizedBox(height: 24),
                                        if (grupoSelecionado != null)
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                passo = 2;
                                                grupoController.text = grupoSelecionado ?? '';
                                                tecidoSelecionado = null;
                                                tecidoController.text = '';
                                                descricaoController.text = '';
                                                _scrollController.jumpTo(0);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green[700],
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              'Próximo',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // topo: voltar
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() => passo = 1);
                                              // rolar para topo ao voltar
                                              _scrollController.jumpTo(0);
                                            },
                                            icon: const Icon(Icons.arrow_back),
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // Editar nome do grupo
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              const Text('Editar nome do grupo:'),
                                              TextField(
                                                controller: grupoController,
                                                decoration: const InputDecoration(
                                                  isDense: true,
                                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Excluir grupo (botão)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // ação mínima: limpar seleção
                                              setState(() {
                                                grupoSelecionado = null;
                                                passo = 1;
                                                grupoController.text = '';
                                              });
                                              _scrollController.jumpTo(0);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Selecionar tecido (pequeno dropdown)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              const Text('Selecionar tecido:'),
                                              const SizedBox(height: 6),
                                              DropdownButtonFormField<String>(
                                                value: tecidoSelecionado,
                                                items: tecidos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                                                onChanged: (v) {
                                                  setState(() {
                                                    tecidoSelecionado = v;
                                                    tecidoController.text = v ?? '';
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                                  filled: true,
                                                  fillColor: const Color(0xFFF8F8F8),
                                                ),
                                                isDense: true,
                                              ),
                                              if (tecidoSelecionado != null) ...[
                                                const SizedBox(height: 8),
                                                Text(tecidoSelecionado!, style: const TextStyle(fontWeight: FontWeight.w500)),
                                              ]
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Excluir tecido
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                tecidoSelecionado = null;
                                                tecidoController.text = '';
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text('Excluir tecido', style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Editar nome do tecido
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              const Text('Editar nome do tecido:'),
                                              TextField(
                                                controller: tecidoController,
                                                decoration: const InputDecoration(
                                                  isDense: true,
                                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Descrição grande
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              const Text('Editar Descrição do tecido:'),
                                              const SizedBox(height: 8),
                                              TextField(
                                                controller: descricaoController,
                                                maxLines: 5,
                                                decoration: const InputDecoration(
                                                  isDense: true,
                                                  contentPadding: EdgeInsets.all(8),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Ações: Cancelar / Confirmar
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                // desfazer e voltar ao passo 1
                                                setState(() {
                                                  passo = 1;
                                                  tecidoSelecionado = null;
                                                  tecidoController.text = '';
                                                  descricaoController.text = '';
                                                });
                                                _scrollController.jumpTo(0);
                                              },
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                                              child: const Text('Cancelar'),
                                            ),
                                            const SizedBox(width: 12),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Ação de confirmar (ainda sem backend) - apenas simula confirmação
                                                setState(() {
                                                  // aqui você poderia persistir alterações localmente
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alterações confirmadas (simulado)')));
                                              },
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent.shade700, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                                              child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ],
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
      },
    );
  }
}