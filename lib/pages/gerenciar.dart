import 'package:flutter/material.dart';

import '../components/barra_lateral.dart';
import '../services/professores_service.dart';

class GerenciarProfessoresPage extends StatefulWidget {
  const GerenciarProfessoresPage({super.key});

  @override
  State<GerenciarProfessoresPage> createState() =>
      _GerenciarProfessoresPageState();
}

class _GerenciarProfessoresPageState extends State<GerenciarProfessoresPage> {
  final List<ProfessorData> _professores = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarProfessores();
  }

  bool _emailValido(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  Future<void> _carregarProfessores() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final lista = await ProfessoresService.listarProfessores();
      setState(() {
        _professores
          ..clear()
          ..addAll(lista);
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar professores: $e';
        _carregando = false;
      });
    }
  }

  // ================= MODAL ADICIONAR =================
  void _mostrarModalAdicionar(BuildContext context) {
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final senhaController = TextEditingController();
    final confirmarSenhaController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    bool obscureSenha = true;
    bool obscureConfirmar = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("Adicionar Professor"),
              content: Form(
                key: formKey,
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nomeController,
                        decoration:
                            const InputDecoration(labelText: "Nome"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o nome';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration:
                            const InputDecoration(labelText: "E-mail"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o e-mail';
                          } else if (!_emailValido(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: senhaController,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          suffixIcon: IconButton(
                            icon: Icon(obscureSenha
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setModalState(() {
                              obscureSenha = !obscureSenha;
                            }),
                          ),
                        ),
                        obscureText: obscureSenha,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite a senha';
                          } else if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: confirmarSenhaController,
                        decoration: InputDecoration(
                          labelText: "Confirmar Senha",
                          suffixIcon: IconButton(
                            icon: Icon(obscureConfirmar
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setModalState(() {
                              obscureConfirmar = !obscureConfirmar;
                            }),
                          ),
                        ),
                        obscureText: obscureConfirmar,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirme a senha';
                          } else if (value != senhaController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar",
                      style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    try {
                      final novo = await ProfessoresService.criarProfessor(
                        nome: nomeController.text,
                        email: emailController.text,
                        senha: senhaController.text,
                      );

                      setState(() {
                        _professores.add(novo);
                      });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Professor adicionado!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao adicionar: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Salvar",
                      style: TextStyle(color: Color(0xFF38853A))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================= MODAL EDITAR =================
  void _mostrarModalEditar(BuildContext context, int index) {
    final professor = _professores[index];

    final nomeController = TextEditingController(text: professor.nome);
    final emailController = TextEditingController(text: professor.email);
    final senhaController = TextEditingController(text: professor.senha);
    final formKey = GlobalKey<FormState>();
    bool obscureSenha = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("Editar Professor"),
              content: Form(
                key: formKey,
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nomeController,
                        decoration:
                            const InputDecoration(labelText: "Nome"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o nome';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration:
                            const InputDecoration(labelText: "E-mail"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o e-mail';
                          } else if (!_emailValido(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: senhaController,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          suffixIcon: IconButton(
                            icon: Icon(obscureSenha
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setModalState(() {
                              obscureSenha = !obscureSenha;
                            }),
                          ),
                        ),
                        obscureText: !obscureSenha,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite a senha';
                          } else if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar",
                      style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final atualizado = ProfessorData(
                      id: professor.id,
                      nome: nomeController.text,
                      email: emailController.text,
                      senha: senhaController.text,
                    );

                    try {
                      final resp = await ProfessoresService
                          .atualizarProfessor(atualizado);

                      setState(() {
                        _professores[index] = resp;
                      });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Professor atualizado!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao atualizar: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Salvar",
                      style: TextStyle(color: Color(0xFF38853A))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================

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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Gerenciar Professores',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: () => _mostrarModalAdicionar(context),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          "Adicionar Professor",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38853A),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    if (_carregando)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    else if (_erro != null)
                      Center(
                        child: Text(
                          _erro!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (_professores.isEmpty)
                      const Center(
                        child: Text(
                          'Nenhum professor cadastrado.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    else
                      ...List.generate(_professores.length, (index) {
                        final professor = _professores[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person,
                                size: 40, color: Colors.black87),
                            title: Text(
                              professor.nome,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              professor.email,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: Wrap(
                              spacing: 12,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.black),
                                  onPressed: () =>
                                      _mostrarModalEditar(context, index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.black),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Confirmar exclusão"),
                                          content: Text(
                                            "Tem certeza que deseja excluir o professor \"${professor.nome}\"?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text("Cancelar",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                try {
                                                  await ProfessoresService
                                                      .excluirProfessor(
                                                          professor.id);
                                                  setState(() {
                                                    _professores
                                                        .removeAt(index);
                                                  });
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Professor "${professor.nome}" excluído'),
                                                  ));
                                                } catch (e) {
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Erro ao excluir: $e'),
                                                    backgroundColor:
                                                        Colors.red,
                                                  ));
                                                }
                                              },
                                              child: const Text("Excluir",
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
