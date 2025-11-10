import 'package:flutter/material.dart';
import '../components/barra_lateral.dart';

class GerenciarProfessoresPage extends StatefulWidget {
  const GerenciarProfessoresPage({super.key});

  @override
  State<GerenciarProfessoresPage> createState() =>
      _GerenciarProfessoresPageState();
}

class _GerenciarProfessoresPageState extends State<GerenciarProfessoresPage> {
  final List<Map<String, String>> professores = [
    {
      "nome": "Aaaaaaaaaaaa Aaaaaaaaaaaaaaaa",
      "email": "aaa@email.com",
      "senha": "123456"
    },
    {
      "nome": "Bbbbbbbbbbbb Bbbbbbbbbbbbbb",
      "email": "bbb@email.com",
      "senha": "abcdef"
    },
    {
      "nome": "Ccccccc Cccccccccccc Ccccccccc",
      "email": "ccc@email.com",
      "senha": "q2er7y"
    },
  ];

  bool _emailValido(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  // Modal de adicionar professor
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
                        decoration: const InputDecoration(labelText: "Nome"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o nome';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "E-mail"),
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        professores.add({
                          "nome": nomeController.text,
                          "email": emailController.text,
                          "senha": senhaController.text,
                        });
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Professor adicionado!')),
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

  // Modal de editar professor
  void _mostrarModalEditar(BuildContext context, int index) {
    final nomeController =
        TextEditingController(text: professores[index]["nome"]);
    final emailController =
        TextEditingController(text: professores[index]["email"]);
    final senhaController =
        TextEditingController(text: professores[index]["senha"]);
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
                        decoration: const InputDecoration(labelText: "Nome"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o nome';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "E-mail"),
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        professores[index] = {
                          "nome": nomeController.text,
                          "email": emailController.text,
                          "senha": senhaController.text,
                        };
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Professor atualizado!')),
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

                    // Botão de adicionar professor
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
                    ...List.generate(professores.length, (index) {
                      final professor = professores[index];
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
                            professor["nome"]!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(professor["email"]!,
                              style: const TextStyle(color: Colors.grey)),
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
                                        title:
                                            const Text("Confirmar exclusão"),
                                        content: Text(
                                            "Tem certeza que deseja excluir o professor \"${professor["nome"]}\"?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("Cancelar",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                professores.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Professor "${professor["nome"]}" excluído'),
                                              ));
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
                    }).toList(),
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
