import 'package:flutter/material.dart';
import 'package:app_pii/services/auth.dart';
import 'package:app_pii/components/barra_lateral.dart';

class PaginaAdicionar extends StatefulWidget {
  const PaginaAdicionar({super.key});

  @override
  State<PaginaAdicionar> createState() => _PaginaAdicionarState();
}

class _PaginaAdicionarState extends State<PaginaAdicionar> {
  String? grupoSelecionado;
  String? tipoSelecionado;
  final TextEditingController _nomeTecidoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final List<String> grupos = ['AAAA', 'BBBB'];
  final List<String> tipos = ['Tipo 1', 'Tipo 2', 'Tipo 3'];
  final List<String> tecidos = ['Tecido 1', 'Tecido 2'];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Auth.isLoggedIn,
      builder: (context, logado, _) {
        if (!logado) {
          return Scaffold(
            backgroundColor: const Color(0xFF44458A),
            body: Center(
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Você precisa estar logado para acessar esta página.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38853A),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Ir para o login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool telaGrande = constraints.maxWidth >= 800;
            return Scaffold(
              backgroundColor: const Color(0xFF44458A),
              drawer: telaGrande ? null : const BarraLateralDrawer(),
              body: Row(
                children: [
                  if (telaGrande) const BarraLateral(),

                  // CONTEÚDO PRINCIPAL
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Container(
                          width: 900,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Selecionar Grupo
                              _buildDropdown(
                                label: 'Selecionar Grupo',
                                value: grupoSelecionado,
                                items: grupos,
                                onChanged: (v) =>
                                    setState(() => grupoSelecionado = v),
                                botaoAdicionar: () => _mostrarDialog(
                                  titulo: 'Adicionar Grupo',
                                  onConfirmar: (texto) =>
                                      setState(() => grupos.add(texto)),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Selecionar Tipo
                              _buildDropdown(
                                label: 'Selecionar Tipo de Tecido',
                                value: tipoSelecionado,
                                items: tipos,
                                onChanged: (v) =>
                                    setState(() => tipoSelecionado = v),
                                botaoAdicionar: () => _mostrarDialog(
                                  titulo: 'Adicionar Tipo',
                                  onConfirmar: (texto) =>
                                      setState(() => tipos.add(texto)),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Selecionar Tecido
                              _buildDropdown(
                                label: 'Selecionar Tecido',
                                value: null,
                                items: tecidos,
                                onChanged: (_) {},
                              ),
                              const SizedBox(height: 20),

                              // Nome do tecido
                              TextField(
                                controller: _nomeTecidoController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome do tecido',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Botões de imagem
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.image),
                                    label: const Text('Inserir imagem',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2196F3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.delete),
                                    label: const Text('Remover imagem',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Descrição
                              TextField(
                                controller: _descricaoController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  labelText: 'Descrição do tecido',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Botões Cancelar / Confirmar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                                    child: const Text('Cancelar',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Tecido adicionado com sucesso!'),
                                      ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                                    child: const Text('Confirmar',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )
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
      },
    );
  }

  // ------- Widgets auxiliares -------
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    VoidCallback? botaoAdicionar,
  }) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
        if (botaoAdicionar != null) ...[
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: botaoAdicionar,
            style: ElevatedButton.styleFrom(
              backgroundColor:Colors.green[700],
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            child: const Text('Adicionar',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ],
    );
  }

  void _mostrarDialog({
    required String titulo,
    required Function(String texto) onConfirmar,
  }) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Digite o nome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onConfirmar(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
