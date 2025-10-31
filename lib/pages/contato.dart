import 'package:flutter/material.dart';
import '../components/barra_lateral.dart';

class PaginaContato extends StatelessWidget {
  const PaginaContato({super.key});

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
                      'Contate-nos!',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Comunicação E Marketing',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: const [
                                Text(
                                  'Gerente de Comunicação e Marketing:',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Renata do Amaral',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                SelectableText(
                                  'renata.amaral@fmabc.br',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: const [
                                Text(
                                  'Analista de Comunicação:',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Regiane Meira',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                SelectableText(
                                  'regiane.meira@fmabc.br',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: const SelectableText(
                              'www.fmabc.br',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Sede: Av. Príncipe de Gales, 821 – Bairro Príncipe de Gales – Santo André – SP – CEP: 09060-650 (Portaria 1)',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
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
  }
}