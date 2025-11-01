import 'package:flutter/material.dart';

class BotaoGrupoTecido extends StatelessWidget {
  final String nomeGrupo;
  final String? imagePath;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const BotaoGrupoTecido({
    Key? key,
    required this.nomeGrupo,
    this.imagePath,
    this.onTap,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(8),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 225,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      img,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  nomeGrupo,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}