import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';
import 'package:app_pii/components/viewer.dart'; 
class PaginaTecido extends StatefulWidget {
  const PaginaTecido({super.key, required this.nome, required this.descricao, required this.referenciasBibliograficas, required this.tileSource});
  final String nome;
  final String descricao;
  final String referenciasBibliograficas;
  final String tileSource;

  @override
  State<PaginaTecido> createState() => _PaginaTecidoState();
}

class _DescricaoCompleta extends StatelessWidget {
  const _DescricaoCompleta({
    required this.descricao,
    required this.referenciasBibliograficas,
  }) : super();

  final String descricao;
  final String referenciasBibliograficas;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          descricao,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          'Referências bibliográficas:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          referenciasBibliograficas,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PaginaTecidoState extends State<PaginaTecido> {
  late Widget _viewer;

  @override
  void initState() {
    super.initState();
    _viewer = Viewer(tileSource: widget.tileSource);
  }

  @override
  void didUpdateWidget(covariant PaginaTecido oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tileSource != widget.tileSource) {
      setState(() {
        _viewer = Viewer(tileSource: widget.tileSource);
      });
    }
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
                                color: Color(0xFF38853A),
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: isNarrow
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              flex: 2,
                              child: _viewer,
                            ),
                            const SizedBox(height: 16, width: 20),
                            Flexible(
                              flex: 3,
                              child: SingleChildScrollView(
                                child: _DescricaoCompleta(
                                  descricao: widget.descricao,
                                  referenciasBibliograficas: widget.referenciasBibliograficas,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: _viewer,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              flex: 2,
                              child: SingleChildScrollView(
                                child: _DescricaoCompleta(
                                  descricao: widget.descricao,
                                  referenciasBibliograficas: widget.referenciasBibliograficas,
                                ),
                              ),
                            ),
                          ],
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