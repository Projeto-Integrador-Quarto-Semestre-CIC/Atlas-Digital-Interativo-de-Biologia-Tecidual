import 'package:flutter/material.dart';
import 'package:app_pii/components/barra_lateral.dart';
import 'package:app_pii/components/viewer.dart'; 
import 'package:app_pii/components/barra_ferramentas.dart';
import 'package:webview_windows/webview_windows.dart' as webview_windows;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import 'package:app_pii/pages/fullscreen_viewer.dart';
 
class PaginaTecido extends StatefulWidget {
  const PaginaTecido({super.key, required this.nome, required this.descricao, required this.referencias, required this.tileSource});
  final String nome;
  final String descricao;
  final String referencias;
  final String tileSource;

  @override
  State<PaginaTecido> createState() => _PaginaTecidoState();
}

class _DescricaoCompleta extends StatelessWidget {
  const _DescricaoCompleta({
    required this.descricao,
    required this.referencias,
  }) : super();

  final String descricao;
  final String referencias;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descrição:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          descricao,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(height: 8),
        const Text(
          'Referências bibliográficas:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          referencias,
          style: const TextStyle(color: Colors.white70, fontSize: 20),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PaginaTecidoState extends State<PaginaTecido> {
   late Widget _viewer;
   WebViewController? _mobileController;
   webview_windows.WebviewController? _windowsController;
   double _zoom = 1.0;
   final double _minZoom = 0.1;
   final double _maxZoom = 100.0;
   bool get _controllersReady => _mobileController != null || _windowsController != null;
   static const double _breakpoint = 900;

  Future<void> _applyZoom(double zoom) async {
    final js = '''
      (function(z){
        if(window.osdBridge){
          if(window.osdBridge.setZoom) return window.osdBridge.setZoom(z);
          if(window.osdBridge.zoomTo) return window.osdBridge.zoomTo(z);
          if(window.osdBridge.setScale) return window.osdBridge.setScale(z);
        }
        return null;
      })(${zoom.toString()});
    ''';

    if (_mobileController != null) {
      await _mobileController!.runJavaScript(js);
    }
    if (_windowsController != null) {
      await _windowsController!.executeScript(js);
    }
  }

  double _sliderToZoom(double s) {
    // zoom = min * (max/min)^s
    return _minZoom * math.pow(_maxZoom / _minZoom, s);
  }

  double _zoomToSlider(double z) {
    return math.log(z / _minZoom) / math.log(_maxZoom / _minZoom);
  }

  Widget _wrapViewer(BuildContext context, Widget viewer, {double minHeight = 500}) {
    final width = MediaQuery.of(context).size.width;
    if (width >= _breakpoint) return viewer;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: viewer,
    );
  }

  @override
  void initState() {
    super.initState();
    print('PaginaTecido: tileSource="${widget.tileSource}" (len=${widget.tileSource.length})');
    print('PaginaTecido: referencias="${widget.referencias}" (len=${widget.referencias.length})');
    // Inicializa o Viewer p/ evitar LaterInitializationError
    _viewer = Viewer(
      tileSource: widget.tileSource,
      onWebViewCreated: (mobile, windows) {
        setState(() {
          _mobileController = mobile;
          _windowsController = windows;
        });
      },
    );

    if (widget.tileSource.isEmpty) {
      print('PaginaTecido: tileSource vazio — verifique DB / fluxo de criação do tecido');
    } else {
      _debugCheckDzi(widget.tileSource);
    }
  }

  Future<void> _debugCheckDzi(String url) async {
    if (url.isEmpty) {
      print('PaginaTecido: tileSource vazio.');
      return;
    }
    try {
      final uri = Uri.parse(url);
      final resp = await http.get(uri);
      print('GET $url -> status ${resp.statusCode}, content-length header: ${resp.headers['content-length']}, bytes: ${resp.bodyBytes.length}');
      if (resp.statusCode == 200) {
        final prefix = String.fromCharCodes(resp.bodyBytes.take(512));
        print('Primeiros bytes / trecho do .dzi:\n${prefix}');
        if (prefix.contains('<Image') || prefix.contains('<?xml')) {
          print('Parece um .dzi válido (contém <?xml ou <Image).');
        } else {
          print('Resposta 200 mas conteúdo não parece .dzi.');
        }
      } else {
        print('Falha ao obter .dzi: ${resp.body}');
      }
    } catch (e) {
      print('Erro ao buscar .dzi: $e');
    }
  }

  @override
  void didUpdateWidget(covariant PaginaTecido oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tileSource != widget.tileSource) {
      setState(() {
        _viewer = Viewer(
          tileSource: widget.tileSource,
          onWebViewCreated: (mobile, windows) {
            setState(() {
              _mobileController = mobile;
              _windowsController = windows;
            });
          },
        );
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
                              child: Column(
                                  children:[
                                    Container(
                                      height: 48,
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                         children: [
                                           IconButton(
                                             icon: const Icon(Icons.reply),
                                             color: const Color(0xFF38853A),
                                             onPressed: () => Navigator.of(context).maybePop(),
                                           ),
                                           SizedBox(width: 8),
                                           Container(width: 1, height: double.infinity, color: Colors.grey[300]),
                                           Expanded(
                                             child: Center(
                                               child: Text(
                                                 widget.nome,
                                                 style: const TextStyle(
                                                   fontSize: 24,
                                                   fontWeight: FontWeight.w600,
                                                   color: Colors.black87,
                                                 ),
                                                 maxLines: 1,
                                                 overflow: TextOverflow.ellipsis,
                                               ),
                                             ),
                                           ),
                                           Container(width: 1, height: double.infinity, color: Colors.grey[300]),
                                           SizedBox(width: 8),
                                           IconButton(
                                             icon: const Icon(Icons.zoom_out_map),
                                             color: const Color(0xFF38853A),
                                             onPressed: () {
                                                Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => FullscreenViewerPage(tileSource: widget.tileSource),
                                                ),
                                              );
                                             },
                                           ),
                                         ],
                                       ),
                                     ),
                                    const SizedBox(height: 6),
                                    Expanded(child: _wrapViewer(context, _viewer)),
                                     BarraFerramentas(
                                       initialSlider: _zoomToSlider(_zoom),
                                       controllersReady: _controllersReady,
                                       sliderWidth: 160,
                                       onApplyZoom: (z) => _applyZoom(z),
                                       onChanged: (s) {
                                         setState(() {
                                           _zoom = _sliderToZoom(s);
                                         });
                                       },
                                     ),
                                  ],
                              ), 
                            ),
                            const SizedBox(height: 16, width: 20),
                            Flexible(
                              flex: 3,
                              child: SingleChildScrollView(
                                child: _DescricaoCompleta(
                                  descricao: widget.descricao,
                                  referencias: widget.referencias,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 48,
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.reply),
                                          color: const Color(0xFF38853A),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                          onPressed: () => Navigator.of(context).maybePop(),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(width: 1, height: double.infinity, color: Colors.grey[300]),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              widget.nome,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Container(width: 1, height: double.infinity, color: Colors.grey[300]),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.zoom_out_map),
                                          color: const Color(0xFF38853A),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => FullscreenViewerPage(tileSource: widget.tileSource),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                   Expanded(
                                     child: Container(
                                       color: Colors.white,
                                       child: _wrapViewer(context, _viewer),
                                     ),
                                   ),
                                    BarraFerramentas(
                                      initialSlider: _zoomToSlider(_zoom),
                                      controllersReady: _controllersReady,
                                      sliderWidth: 160,
                                      onApplyZoom: (z) => _applyZoom(z),
                                      onChanged: (s) {
                                        setState(() {
                                          _zoom = _sliderToZoom(s);
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              flex: 2,
                              child: SingleChildScrollView(
                                child: _DescricaoCompleta(
                                  descricao: widget.descricao,
                                  referencias: widget.referencias,
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