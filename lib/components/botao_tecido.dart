import 'dart:math' as math;
import 'package:flutter/material.dart';

class BotaoTecido extends StatelessWidget {
  final String titulo;
  final String? imagePath;      // caminho de asset, ex: 'uploads/grupos/arquivo.png'
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

  Widget _buildImage() {
    const String placeholderAsset = 'assets/images/no_img.png';

    if (imagePath == null || imagePath!.isEmpty) {
      return Image.asset(
        placeholderAsset,
        fit: BoxFit.contain,
      );
    }

    final path = imagePath!;

    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Erro ao carregar asset de imagem ($path): $error');
        return Image.asset(
          placeholderAsset,
          fit: BoxFit.contain,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxCellWidth = constraints.maxWidth;
                final double maxCellHeight =
                    constraints.hasBoundedHeight ? constraints.maxHeight : double.infinity;

                final double verticalPadding =
                    (padding is EdgeInsets) ? (padding as EdgeInsets).vertical : 16.0;

                const double estimatedTitleHeight = 44.0;
                const double spacing = 8.0;

                final double reservedForText =
                    estimatedTitleHeight + spacing + verticalPadding;

                final double imageSize = math.max(
                  0.0,
                  math.min(
                    math.min(maxCellWidth, 225.0),
                    maxCellHeight == double.infinity
                        ? 225.0
                        : (maxCellHeight - reservedForText),
                  ),
                );

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: imageSize,
                      width: imageSize,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _buildImage(),
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
