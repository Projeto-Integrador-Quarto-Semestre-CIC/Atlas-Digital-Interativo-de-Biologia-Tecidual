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

  void _selecionarGrupo(String grupo) {
    setState(() {
      grupoSelecionado = grupo;
    });
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
                          constraints: const BoxConstraints(maxWidth: 500),
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
                          child: Column(
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
                          ),
                        ),
                      ],
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