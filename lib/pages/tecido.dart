import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';
import 'package:app_pii/components/viewer.dart'; 

class TelaTecido extends StatefulWidget {
  const TelaTecido({super.key, required this.nome, required this.descricao, required this.referenciasBibliograficas, required this.tileSource});
  final String nome;
  final String descricao;
  final String referenciasBibliograficas;
  final String tileSource;

  @override
  State<TelaTecido> createState() => _TelaTecidoState();
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

class _TelaTecidoState extends State<TelaTecido> {

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        const double breakpoint = 900;
        final isNarrow = constraints.maxWidth < breakpoint;

        return Scaffold(
          backgroundColor: const Color(0xFF4B5190),
          drawer: isNarrow ? const BarraLateralDrawer() : null,

          appBar: isNarrow
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                )
              : null,
          body: Row(
            children: [
              if (!isNarrow) const BarraLateral(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: isNarrow
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Container(
                                color: Colors.red,
                              ),
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
                              child: Container(
                                height: 600,
                                child: Viewer(tileSource: widget.tileSource)
                              ),
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