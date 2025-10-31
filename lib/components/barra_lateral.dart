import 'package:flutter/material.dart';

class BotaoHome extends StatelessWidget {
  final bool? sidebar;
  const BotaoHome({super.key, this.sidebar});

  @override
  Widget build(BuildContext context){
    final bool isSidebar = sidebar ?? (MediaQuery.of(context).size.width >= 800);

    if (isSidebar) {
      return TextButton(
        onPressed: () { Navigator.of(context).popUntil((route) => route.isFirst); },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size.fromHeight(130),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 130,
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: Center(
        child: SizedBox.square(
          dimension: 250,
          child: InkWell(
            onTap: () { Navigator.of(context).popUntil((route) => route.isFirst); },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
    );
  } 
}

class _SidebarContent extends StatelessWidget {
  const _SidebarContent();

  @override
  Widget build(BuildContext context) {
    final bool telaGrande = MediaQuery.of(context).size.width >= 800;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (telaGrande) const BotaoHome(sidebar: true),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white, width: 2))),
            child: TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/login'), // TODO: código que leva pra LOGIN
                icon: const Icon(Icons.person, size: 30, color: Colors.white),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("LOGIN PARA EDITORES"),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  alignment: Alignment.centerLeft,
                )),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white, width: 2))),
            child: TextButton.icon(
                onPressed: () {print("EXPLORAR CLICADO!");}, // TODO: código que leva pra EXPLORAR
                icon: const Icon(Icons.search, size: 30, color: Colors.white),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("EXPLORAR"),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  alignment: Alignment.centerLeft,
                )),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white, width: 2))),
            child: TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/contato'),
                icon: const Icon(Icons.phone, size: 30, color: Colors.white),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("CONTATO"),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  alignment: Alignment.centerLeft,
                )),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, this.width = 280});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: const Color(0xFF38853A),
      child: const _SidebarContent(),
    );
  }
}

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: const Color(0xFF38853A),
      child: const _SidebarContent(),
    );
  }
}

// Backwards-compatible aliases: alguns testes/parts do projeto ainda esperam
// os nomes antigos `BarraLateral` / `BarraLateralDrawer`. Mantemos aliases
// leves para não quebrar integrações existentes.
class BarraLateral extends Sidebar {
  const BarraLateral({super.key, double width = 280}) : super(width: width);
}

class BarraLateralDrawer extends SidebarDrawer {
  const BarraLateralDrawer({super.key});
}