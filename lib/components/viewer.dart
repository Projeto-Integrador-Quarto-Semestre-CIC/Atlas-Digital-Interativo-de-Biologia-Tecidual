import 'dart:convert' show utf8, json;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart' as webview_windows;

class Viewer extends StatefulWidget {

  static bool modoTeste = false; // Desabilita o Viewer para não gerar erros nos testes

  final String assetPath = 'assets/web/viewer.html';
  final String tileSource;
  const Viewer({super.key, required this.tileSource}) : super();

  @override
  State<Viewer> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  WebViewController? _mobileController;
  webview_windows.WebviewController? _windowsController;

  @override
  void initState() {
    super.initState();
    if (!Viewer.modoTeste){
      _initWebView();
    }
  }

  Future<void> _initWebView() async {
    var htmlString = await rootBundle.loadString(widget.assetPath);

    htmlString = htmlString.replaceAll('__TILE_SOURCE__', json.encode(widget.tileSource));

    if (defaultTargetPlatform == TargetPlatform.windows) {
      final controller = webview_windows.WebviewController();
      await controller.initialize();
      await controller.loadStringContent(htmlString);
      setState(() => _windowsController = controller);
    } else {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.dataFromString(htmlString, mimeType: 'text/html', encoding: utf8));
      setState(() => _mobileController = controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Builder(builder: (context) {
        if(Viewer.modoTeste){
          return const SizedBox.expand(
            child: Center(child: Text("Viewer desabilitado para testes.")),
          );
        }

        if (defaultTargetPlatform == TargetPlatform.windows) {
          if (_windowsController == null) return const Center(child: CircularProgressIndicator());
          return webview_windows.Webview(_windowsController!);
        } else {
          if (_mobileController == null) return const Center(child: CircularProgressIndicator());
          return WebViewWidget(controller: _mobileController!);
        }
      }),
    );
  }

  @override
  void dispose() {
    _windowsController?.dispose();
    super.dispose();
  }
}