import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';
import 'package:app_pii/services/auth.dart';
import 'package:app_pii/services/tecidos_service.dart';

class PaginaEditar extends StatefulWidget {
  const PaginaEditar({super.key});

  @override
  State<PaginaEditar> createState() => _PaginaEditarState();
}

class _PaginaEditarState extends State<PaginaEditar> {
  // Seleções atuais
  String? _grupoSelecionado; // nome do grupo
  String? _tipoSelecionado;  // nome do tipo

  // Dados carregados
  List<GrupoTecidoData> _grupos = [];
  List<String> _tipos = [];
  List<TecidoData> _tecidosDoGrupo = [];

  // Tecido em edição (do grupo/tipo selecionados)
  TecidoData? _tecidoSelecionado;

  // Controllers
  final _nomeCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();

  // Estados de carregamento/erro
  bool _loadingGrupos = true;
  String? _erroGrupos;
  bool _loadingTipos = false;
  bool _loadingTecido = false;

  @override
  void initState() {
    super.initState();
    _carregarGrupos();
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  // ----- Carregamentos -----

  Future<void> _carregarGrupos() async {
    setState(() {
      _loadingGrupos = true;
      _erroGrupos = null;
      _grupos = [];
      _grupoSelecionado = null;
      _tipoSelecionado = null;
      _tipos = [];
      _tecidosDoGrupo = [];
      _tecidoSelecionado = null;
      _nomeCtrl.clear();
      _descricaoCtrl.clear();
    });

    try {
      final grupos = await TecidosService.listarGrupos();
      if (!mounted) return;
      setState(() {
        _grupos = grupos;
        _loadingGrupos = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingGrupos = false;
        _erroGrupos = 'Erro ao carregar grupos: $e';
      });
    }
  }

  Future<void> _onSelecionarGrupo(String? grupo) async {
    setState(() {
      _grupoSelecionado = grupo;
      _tipoSelecionado = null;
      _tipos = [];
      _tecidosDoGrupo = [];
      _tecidoSelecionado = null;
      _nomeCtrl.clear();
      _descricaoCtrl.clear();
      _loadingTipos = true;
    });

    if (grupo == null) {
      setState(() => _loadingTipos = false);
      return;
    }

    try {
      final tipos = await TecidosService.listarTiposPorGrupo(grupo);
      final tecidos = await TecidosService.listarTecidosPorGrupo(grupo);
      if (!mounted) return;
      setState(() {
        _tipos = tipos;
        _tecidosDoGrupo = tecidos;
        _loadingTipos = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingTipos = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar tipos/tecidos: $e')),
      );
    }
  }

  Future<void> _onSelecionarTipo(String? tipo) async {
    setState(() {
      _tipoSelecionado = tipo;
      _tecidoSelecionado = null;
      _nomeCtrl.clear();
      _descricaoCtrl.clear();
      _loadingTecido = true;
    });

    if (tipo == null) {
      setState(() => _loadingTecido = false);
      return;
    }

    // Pega o primeiro tecido daquele tipo dentro do grupo selecionado
    final t = _tecidosDoGrupo.where((x) => x.tipo == tipo).toList();
    if (t.isEmpty) {
      // Não existe tecido para esse tipo → mantém campos vazios (edição desabilitada)
      setState(() {
        _loadingTecido = false;
        _tecidoSelecionado = null;
        _nomeCtrl.text = '';
        _descricaoCtrl.text = '';
      });
      return;
    }

    final selecionado = t.first;
    setState(() {
      _tecidoSelecionado = selecionado;
      _nomeCtrl.text = selecionado.nome;
      _descricaoCtrl.text = selecionado.texto;
      _loadingTecido = false;
    });
  }

  // ----- Ações -----

  Future<void> _confirmarEdicao() async {
    final t = _tecidoSelecionado;
    if (t == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum tecido carregado para editar.')),
      );
      return;
    }

    try {
      // cria uma cópia atualizada só com os campos que mudam
      final atualizado = TecidoData(
        id: t.id,
        grupo: t.grupo,                 // mantém
        tipo: t.tipo,                   // mantém
        nome: _nomeCtrl.text.trim(),    // altera
        texto: _descricaoCtrl.text.trim(), // altera
        imagem: t.imagem,               // mantém
      );

      final salvo = await TecidosService.atualizarTecido(atualizado);

      if (!mounted) return;
      setState(() {
        _tecidoSelecionado = salvo;
        final i = _tecidosDoGrupo.indexWhere((x) => x.id == salvo.id);
        if (i >= 0) _tecidosDoGrupo[i] = salvo;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tecido atualizado com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao atualizar tecido: $e')),
      );
    }
  }

  Future<void> _excluirTecido() async {
    final t = _tecidoSelecionado;
    if (t == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um tecido para excluir.')),
      );
      return;
    }

    final conf = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir tecido'),
        content: Text('Excluir o tecido "${t.nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (conf != true) return;

    try {
      await TecidosService.excluirTecido(t.id);
      if (!mounted) return;
      setState(() {
        _tecidosDoGrupo.removeWhere((x) => x.id == t.id);
        _tecidoSelecionado = null;
        _nomeCtrl.clear();
        _descricaoCtrl.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tecido excluído.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao excluir tecido: $e')),
      );
    }
  }

  Future<void> _excluirGrupoSelecionado() async {
    final gNome = _grupoSelecionado;
    if (gNome == null) return;

    final g = _grupos.firstWhere(
      (x) => x.grupo == gNome,
      orElse: () => GrupoTecidoData(id: -1, grupo: gNome, imagem: ''),
    );
    if (g.id == -1) return;

    final conf = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir grupo'),
        content: Text('Excluir o grupo "$gNome" e seus tecidos?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (conf != true) return;

    try {
      await TecidosService.excluirGrupo(g.id);
      if (!mounted) return;
      await _carregarGrupos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grupo excluído.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao excluir grupo: $e')),
      );
    }
  }

  // ----- UI -----

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
                              // ------ Selecionar Grupo + Deletar ------
                              if (_loadingGrupos)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (_erroGrupos != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(_erroGrupos!, style: const TextStyle(color: Colors.red)),
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: _grupoSelecionado,
                                        decoration: const InputDecoration(
                                          labelText: 'Selecionar Grupo',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: _grupos
                                            .map((g) => DropdownMenuItem(
                                                  value: g.grupo,
                                                  child: Text(g.grupo),
                                                ))
                                            .toList(),
                                        onChanged: (v) => _onSelecionarGrupo(v),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: _grupoSelecionado == null ? null : _excluirGrupoSelecionado,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      ),
                                      child: const Text('Deletar', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 20),

                              // ------ Selecionar Tipo (habilita quando o grupo está carregado) ------
                              IgnorePointer(
                                ignoring: _grupoSelecionado == null || _loadingTipos,
                                child: Opacity(
                                  opacity: (_grupoSelecionado == null || _loadingTipos) ? 0.6 : 1.0,
                                  child: DropdownButtonFormField<String>(
                                    value: _tipoSelecionado,
                                    decoration: const InputDecoration(
                                      labelText: 'Selecionar Tipo de Tecido',
                                      border: OutlineInputBorder(),
                                    ),
                                    items: _tipos
                                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                        .toList(),
                                    onChanged: (v) => _onSelecionarTipo(v),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // ------ Campos de edição (aparecem quando há tipo escolhido) ------
                              if (_tipoSelecionado != null) ...[
                                TextField(
                                  controller: _nomeCtrl,
                                  enabled: !_loadingTecido && _tecidoSelecionado != null,
                                  decoration: const InputDecoration(
                                    labelText: 'Nome do tecido',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: _descricaoCtrl,
                                  enabled: !_loadingTecido && _tecidoSelecionado != null,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    labelText: 'Descrição do tecido',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (_tecidoSelecionado == null || _loadingTecido)
                                          ? null
                                          : _excluirTecido,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                      child: const Text('Excluir tecido', style: TextStyle(color: Colors.white)),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: (_tecidoSelecionado == null || _loadingTecido)
                                          ? null
                                          : _confirmarEdicao,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                      child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
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
}
