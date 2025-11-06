import 'dart:math' as math;
import 'package:flutter/material.dart';

class BotaoTecido extends StatelessWidget {
  final String titulo;
  final String? imagePath;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color corTitulo;

  const BotaoTecido({
    Key? key,
    required this.titulo,
    this.imagePath,
    this.onTap,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(8),
    this.corTitulo = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final img = imagePath ?? 'assets/images/no_img.png';
    
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              final double maxCellWidth = constraints.maxWidth;
              final double imageSize = math.min(maxCellWidth, 225);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: imageSize,
                    width: imageSize,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        img,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: imageSize,
                    child: Text(
                      titulo,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: corTitulo,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}