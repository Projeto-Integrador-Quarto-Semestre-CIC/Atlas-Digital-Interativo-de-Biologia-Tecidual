import 'package:flutter/material.dart';
import 'package:app_pii/services/auth.dart';

class BotaoHome extends StatelessWidget {
  final bool? sidebar;
  const BotaoHome({super.key, this.sidebar});

  @override
  Widget build(BuildContext context) {
    final bool isSidebar = sidebar ?? (MediaQuery.of(context).size.width >= 800);

    if (isSidebar) {
      return TextButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
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
            onTap: () {
              if (Scaffold.of(context).hasDrawer) {
                Navigator.of(context).pop();
              }
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
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
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    // Função auxiliar para criar botões com destaque da rota atual
    Widget buildSidebarButton({
      required String label,
      required String route,
      required IconData icon,
    }) {
      final bool isActive = currentRoute == route;
      return Container(
        decoration: BoxDecoration(
          border: const Border(bottom: BorderSide(color: Colors.white, width: 2)),
          color: isActive ? const Color(0xFF2E6C33) : Colors.transparent,
        ),
        child: TextButton.icon(
          onPressed: () {
            if (!isActive) Navigator.pushNamed(context, route);
          },
          icon: Icon(icon, size: 30, color: Colors.white),
          label: Align(
            alignment: Alignment.centerLeft,
            child: Text(label),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            textStyle: const TextStyle(fontSize: 20),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.centerLeft,
          ),
        ),
      );
    }

    return SafeArea(
      child: ValueListenableBuilder<bool>(
        valueListenable: Auth.isLoggedIn,
        builder: (context, loggedIn, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (telaGrande) const BotaoHome(sidebar: true),

              buildSidebarButton(
                label: 'LOGIN PARA EDITORES',
                route: '/login',
                icon: Icons.person,
              ),
              buildSidebarButton(
                label: 'EXPLORAR',
                route: '/explorar',
                icon: Icons.search,
              ),
              buildSidebarButton(
                label: 'CONTATO',
                route: '/contato',
                icon: Icons.phone,
              ),

              // Estes só aparecem se o usuário estiver logado
              if (loggedIn) ...[
                buildSidebarButton(
                  label: 'EDITAR',
                  route: '/editar',
                  icon: Icons.edit,
                ),
                buildSidebarButton(
                  label: 'ADICIONAR',
                  route: '/adicionar',
                  icon: Icons.add_box,
                ),
              ],
            ],
          );
        },
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

class BarraLateral extends Sidebar {
  const BarraLateral({super.key, double width = 280}) : super(width: width);
}

class BarraLateralDrawer extends SidebarDrawer {
  const BarraLateralDrawer({super.key});
}
