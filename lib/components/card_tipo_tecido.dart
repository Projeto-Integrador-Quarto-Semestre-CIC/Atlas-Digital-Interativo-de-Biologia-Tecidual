import 'package:flutter/material.dart';

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

class _CardTipoTecidoState extends State<CardTipoTecido>
    with TickerProviderStateMixin {
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
            // Cabeçalho (título + seta)
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: _toggle,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                        turns: _rotateController.drive(
                          Tween(begin: 0.0, end: 0.5),
                        ),
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

            // linha verde
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: _expanded ? 2.0 : 0.0,
              width: double.infinity,
              color: const Color(0xFF38853A),
            ),

            // Conteúdo expandido (vem TODO de fora)
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: widget.expandedChild ??
                      const Text(
                        'Nenhum tecido cadastrado para este tipo.',
                        textAlign: TextAlign.center,
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
