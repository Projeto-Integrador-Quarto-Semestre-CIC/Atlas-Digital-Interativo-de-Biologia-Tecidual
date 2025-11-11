import 'dart:math' as math;
import 'package:flutter/material.dart';

const String _baseUrlImagens = 'http://localhost:3000';

class BotaoTecido extends StatelessWidget {
  final String titulo;
  final String? imagePath;      // pode ser /grupos/..., http..., ou asset
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
    // asset padrão
    const String placeholderAsset = 'assets/images/no_img.png';

    // se não veio nada do banco, usa placeholder
    if (imagePath == null || imagePath!.isEmpty) {
      return Image.asset(
        placeholderAsset,
        fit: BoxFit.contain,
      );
    }

    final String path = imagePath!;

    // se já é URL completa
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            placeholderAsset,
            fit: BoxFit.contain,
          );
        },
      );
    }

    // se começa com "/", é caminho do servidor (ex: /grupos/epitelial.png)
    if (path.startsWith('/')) {
      final url = '$_baseUrlImagens$path';
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            placeholderAsset,
            fit: BoxFit.contain,
          );
        },
      );
    }

    // senão, tratamos como asset relativo
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
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
