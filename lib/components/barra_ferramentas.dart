import 'package:flutter/material.dart';
import 'dart:math' as math;

class BarraFerramentas extends StatefulWidget {
  final double initialSlider;
  final double sliderWidth;
  final bool controllersReady;
  final ValueChanged<double>? onApplyZoom;
  final ValueChanged<double>? onChanged;

  const BarraFerramentas({
    super.key,
    this.initialSlider = 0.25,
    this.sliderWidth = 160.0,
    this.controllersReady = true,
    this.onApplyZoom,
    this.onChanged,
  });

  @override
  State<BarraFerramentas> createState() => _BarraFerramentasState();
}

class _BarraFerramentasState extends State<BarraFerramentas> {
  late double _slider;
  double _minZoom = 0.1;
  double _maxZoom = 100.0;

  @override
  void initState() {
    super.initState();
    _slider = widget.initialSlider.clamp(0.0, 1.0);
  }

  @override
  void didUpdateWidget(covariant BarraFerramentas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSlider != widget.initialSlider) {
      _slider = widget.initialSlider.clamp(0.0, 1.0);
    }
  }

  double _sliderToZoom(double s) {
    return _minZoom * math.pow(_maxZoom / _minZoom, s);
  }

  double _zoomToSlider(double z) {
    return math.log(z / _minZoom) / math.log(_maxZoom / _minZoom);
  }

  void _applyZoomFromSlider(double s) {
    final zoom = _sliderToZoom(s);
    widget.onApplyZoom?.call(zoom);
  }

  void _onSliderChanged(double s) {
    setState(() => _slider = s);
    widget.onChanged?.call(s);
    _applyZoomFromSlider(s);
  }

  void _zoomIn() {
    final zoom = (_sliderToZoom(_slider) * 1.5).clamp(_minZoom, _maxZoom);
    final s = _zoomToSlider(zoom).clamp(0.0, 1.0);
    setState(() => _slider = s);
    widget.onChanged?.call(s);
    widget.onApplyZoom?.call(zoom);
  }

  void _zoomOut() {
    final zoom = (_sliderToZoom(_slider) / 1.5).clamp(_minZoom, _maxZoom);
    final s = _zoomToSlider(zoom).clamp(0.0, 1.0);
    setState(() => _slider = s);
    widget.onChanged?.call(s);
    widget.onApplyZoom?.call(zoom);
  }

  String _zoomText() {
    final z = _sliderToZoom(_slider);
    if (z >= 10) return '${z.toStringAsFixed(0)}x';
    if (z >= 1) return '${z.toStringAsFixed(1)}x';
    return '${z.toStringAsFixed(2)}x';
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF38853A);
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 64,
            child: Text(
              _zoomText(),
              style: const TextStyle(color: green, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove, color: green),
            onPressed: widget.controllersReady ? _zoomOut : null,
            tooltip: 'Zoom out',
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: widget.sliderWidth,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const _RectangularThumbShape(width: 10, height: 18),
                thumbColor: green,
                activeTrackColor: green,
                inactiveTrackColor: Colors.grey,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: _slider,
                min: 0.0,
                max: 1.0,
                divisions: 100,
                onChanged: widget.controllersReady ? _onSliderChanged : null,
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.add, color: green),
            onPressed: widget.controllersReady ? _zoomIn : null,
            tooltip: 'Zoom in',
          ),
        ],
      ),
    );
  }
}

class _RectangularThumbShape extends SliderComponentShape {
  final double width;
  final double height;
  const _RectangularThumbShape({this.width = 10.0, this.height = 18.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(width, height);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final rect = Rect.fromCenter(center: center, width: width, height: height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));
    final paint = Paint()..color = sliderTheme.thumbColor ?? sliderTheme.activeTrackColor ?? Colors.black;
    canvas.drawRRect(rrect, paint);
  }
}