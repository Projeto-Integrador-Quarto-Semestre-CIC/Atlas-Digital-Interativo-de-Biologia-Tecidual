import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:app_pii/services/auth.dart';
import 'package:app_pii/components/barra_lateral.dart';
import 'package:app_pii/services/tecidos_service.dart';

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

  // NOVO: campo de referência
  final TextEditingController _referenciaController = TextEditingController();

  List<GrupoTecidoData> _grupos = [];
  List<String> _tipos = [];

  bool _carregandoGrupos = true;
  String? _erroGrupos;

  // imagem do TECIDO
  Uint8List? _imagemTecidoBytes;
  String? _imagemTecidoNome;

  // imagem do GRUPO (quando adicionar grupo)
  Uint8List? _imagemGrupoBytes;
  String? _imagemGrupoNome;

  @override
  void initState() {
    super.initState();
    _carregarGrupos();
  }

  Future<void> _carregarGrupos() async {
    setState(() {
      _carregandoGrupos = true;
      _erroGrupos = null;
    });

    try {
      final grupos = await TecidosService.listarGrupos();
      setState(() {
        _grupos = grupos;
        _carregandoGrupos = false;
      });
    } catch (e) {
      setState(() {
        _carregandoGrupos = false;
        _erroGrupos = 'Erro ao carregar grupos: $e';
      });
    }
  }

  Future<void> _carregarTipos(String grupo) async {
    final tipos = await TecidosService.listarTiposPorGrupo(grupo);
    setState(() {
      _tipos = tipos;
      tipoSelecionado = null;
    });
  }

  @override
  void dispose() {
    _nomeTecidoController.dispose();
    _descricaoController.dispose();
    _referenciaController.dispose(); // NOVO
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Auth.isLoggedIn,
      builder: (context, logado, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final bool telaGrande = constraints.maxWidth >= 800;
            return Scaffold(
              backgroundColor: const Color(0xFF44458A),
              drawer: telaGrande ? null : const BarraLateralDrawer(),
              body: Row(
                children: [
                  if (telaGrande) const BarraLateral(),

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
                              // ------- Selecionar Grupo -------
                              if (_carregandoGrupos)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (_erroGrupos != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    _erroGrupos!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                )
                              else
                                _buildDropdown(
                                  label: 'Selecionar Grupo',
                                  value: grupoSelecionado,
                                  items: _grupos.map((g) => g.grupo).toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      grupoSelecionado = v;
                                      tipoSelecionado = null;
                                      _tipos = [];
                                    });
                                    if (v != null) {
                                      _carregarTipos(v);
                                    }
                                  },
                                  botaoAdicionar: _mostrarDialogAdicionarGrupo,
                                ),
                              const SizedBox(height: 20),

                              // ------- Selecionar Tipo -------
                              _buildDropdown(
                                label: 'Selecionar Tipo de Tecido',
                                value: tipoSelecionado,
                                items: _tipos,
                                onChanged: (v) =>
                                    setState(() => tipoSelecionado = v),
                                botaoAdicionar: () => _mostrarDialogSimples(
                                  titulo: 'Adicionar Tipo',
                                  onConfirmar: (texto) => setState(() {
                                    if (!_tipos.contains(texto)) {
                                      _tipos.add(texto);
                                      tipoSelecionado = texto;
                                    }
                                  }),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ------- Nome do tecido -------
                              TextField(
                                controller: _nomeTecidoController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome do tecido',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ------- Botões de imagem do TECIDO -------
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.image,
                                        withData: true,
                                      );

                                      if (result != null &&
                                          result.files.isNotEmpty) {
                                        final file = result.files.single;
                                        if (file.bytes != null) {
                                          setState(() {
                                            _imagemTecidoBytes = file.bytes;
                                            _imagemTecidoNome = file.name;
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Imagem selecionada: ${file.name}'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.image,
                                    color: Colors.white,),
                                    label: const Text(
                                      'Inserir imagem',
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
                                    onPressed: () {
                                      setState(() {
                                        _imagemTecidoBytes = null;
                                        _imagemTecidoNome = null;
                                      });
                                    },
                                    icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                    label: const Text(
                                      'Remover imagem',
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

                              if (_imagemTecidoBytes != null) ...[
                                const SizedBox(height: 12),
                                Center(
                                  child: Image.memory(
                                    _imagemTecidoBytes!,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 20),

                              // ------- Descrição -------
                              TextField(
                                controller: _descricaoController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  labelText: 'Descrição do tecido',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ------- Referência -------
                              TextField(
                                controller: _referenciaController,
                                decoration: const InputDecoration(
                                  labelText: 'Referência do tecido',
                                  hintText:
                                      'Ex: Referência bibliográfica de origem ou link',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // ------- Botões Cancelar / Confirmar -------
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
                                    onPressed: _salvarTecido,
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
            onChanged: items.isEmpty ? null : onChanged,
          ),
        ),
        if (botaoAdicionar != null) ...[
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: botaoAdicionar,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            child: const Text(
              'Adicionar',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ],
    );
  }

  void _mostrarDialogSimples({
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
              final txt = controller.text.trim();
              if (txt.isNotEmpty) {
                onConfirmar(txt);
              }
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogAdicionarGrupo() {
    final nomeCtrl = TextEditingController();
    _imagemGrupoBytes = null;
    _imagemGrupoNome = null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Adicionar Grupo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Nome do grupo'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            withData: true,
                          );

                          if (result != null && result.files.isNotEmpty) {
                            final file = result.files.single;
                            if (file.bytes != null) {
                              setStateDialog(() {
                                _imagemGrupoBytes = file.bytes;
                                _imagemGrupoNome = file.name;
                              });
                            }
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text('Selecionar imagem'),
                      ),
                      const SizedBox(width: 8),
                      if (_imagemGrupoNome != null)
                        Expanded(
                          child: Text(
                            _imagemGrupoNome!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  if (_imagemGrupoBytes != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: Image.memory(
                        _imagemGrupoBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    final nome = nomeCtrl.text.trim();
                    if (nome.isEmpty) return;

                    String imagemPath = '';

                    if (_imagemGrupoBytes != null &&
                        _imagemGrupoNome != null) {
                      final path = await TecidosService.uploadImagemGrupo(
                        nomeArquivo: _imagemGrupoNome!,
                        bytes: _imagemGrupoBytes!,
                      );
                      if (path != null) {
                        imagemPath = path;
                      }
                    }

                    final ok = await TecidosService.criarGrupo(
                      grupo: nome,
                      imagem: imagemPath,
                    );

                    if (ok) {
                      Navigator.pop(context);
                      await _carregarGrupos();
                      setState(() {
                        grupoSelecionado = nome;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao salvar grupo no servidor.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _salvarTecido() async {
    final grupo = grupoSelecionado;
    final tipo = tipoSelecionado;
    final nome = _nomeTecidoController.text.trim();
    final texto = _descricaoController.text.trim();

    if (grupo == null || tipo == null || nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha grupo, tipo e nome do tecido.'),
        ),
      );
      return;
    }

    String imagemPath = '';

    if (_imagemTecidoBytes != null && _imagemTecidoNome != null) {
      final path = await TecidosService.uploadImagemTecido(
        nomeArquivo: _imagemTecidoNome!,
        bytes: _imagemTecidoBytes!,
      );
      if (path != null) {
        imagemPath = path;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao enviar imagem do tecido.'),
          ),
        );
        return;
      }
    }

    final ok = await TecidosService.criarTecido(
      grupo: grupo,
      tipo: tipo,
      nome: nome,
      texto: texto,
      imagem: imagemPath,
    );

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tecido adicionado com sucesso!'),
        ),
      );
      setState(() {
        _nomeTecidoController.clear();
        _descricaoController.clear();
        _referenciaController.clear();
        _imagemTecidoBytes = null;
        _imagemTecidoNome = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar tecido no servidor.'),
        ),
      );
    }
  }
}
