import 'package:flutter/material.dart';
import '../components/barra_lateral.dart';
import '../components/card_tipo_tecido.dart';

class PaginaGrupoTecido extends StatelessWidget {
  const PaginaGrupoTecido({super.key});

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
                  constraints: const BoxConstraints(maxWidth: 1500, maxHeight: 900, minWidth: 300),
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
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF38853A)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'NOME DO GRUPO DE TECIDO',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 52),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(top: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CardTipoTecido(
                                  titulo: 'TIPO DE TECIDO A',
                                ),
                                const SizedBox(height: 12),
                                CardTipoTecido(
                                  titulo: 'TIPO DE TECIDO B',
                                ),
                                const SizedBox(height: 12),
                                CardTipoTecido(
                                  titulo: 'TIPO DE TECIDO C',
                                ),
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