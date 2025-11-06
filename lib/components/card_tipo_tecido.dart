import 'package:flutter/material.dart';
import 'package:app_pii/components/botao_tecido.dart';

class CardTipoTecido extends StatefulWidget {
  final String titulo;
  final Widget? expandedChild;
  final bool initiallyExpanded;
  final VoidCallback? onTapHeader;

  const CardTipoTecido({
    super.key,
    required this.titulo,
    this.expandedChild,
    this.initiallyExpanded = false,
    this.onTapHeader,
  });

  @override
  State<CardTipoTecido> createState() => _CardTipoTecidoState();
}

class _CardTipoTecidoState extends State<CardTipoTecido> with TickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: _expanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _rotateController.forward();
    } else {
      _rotateController.reverse();
    }
    widget.onTapHeader?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: _toggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      RotationTransition(
                        turns: _rotateController.drive(Tween(begin: 0.0, end: 0.5)),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          color: const Color(0xFF38853A),
                          onPressed: _toggle,
                          tooltip: _expanded ? 'Fechar' : 'Abrir',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: _expanded ? 2.0 : 0.0,
              width: double.infinity,
              color: const Color(0xFF38853A),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: _expanded
                    ? const BoxConstraints()
                    : const BoxConstraints(maxHeight: 0.0),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: widget.expandedChild ?? //dps remover ao implementar backend. Se n tem nada, mostrar apenas "Em construção..."
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: MediaQuery.of(context).size.width >= 800 ? 4 : 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: MediaQuery.of(context).size.width >= 800 ? 0.85 : 0.75,
                        children: [
                          BotaoTecido(
                            titulo: 'Tecido X',
                            corTitulo:Colors.black,
                            onTap: () {
                              // TODO: abrir tela referente ao tecido
                                Navigator.pushNamed(context, '/tecido');
                            },
                          ),
                          BotaoTecido(
                            titulo: 'Tecido Y',
                            corTitulo:Colors.black,
                            onTap: () {
                              // TODO: abrir tela referente ao tecido
                                Navigator.pushNamed(context, '/tecido');
                            },
                          ),
                          BotaoTecido(
                            titulo: 'Tecido Z',
                            corTitulo:Colors.black,
                            onTap: () {
                              // TODO: abrir tela referente ao tecido
                                Navigator.pushNamed(context, '/tecido');
                            },
                          ),
                          BotaoTecido(
                            titulo: 'Tecido ALFA',
                            corTitulo:Colors.black,
                            onTap: () {
                              // TODO: abrir tela referente ao tecido
                                Navigator.pushNamed(context, '/tecido');
                            },
                          ),
                          BotaoTecido(
                            titulo: 'Tecido BETA',
                            corTitulo:Colors.black,
                            onTap: () {
                              // TODO: abrir tela referente ao tecido
                                Navigator.pushNamed(context, '/tecido');
                            },
                          ),
                        ],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}