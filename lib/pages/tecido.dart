import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart' show rootBundle;

import 'package:webview_flutter/webview_flutter.dart'
    if (dart.library.io) 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart' as webview_windows;

class TelaTecido extends StatefulWidget {
  const TelaTecido({super.key});

  @override
  State<TelaTecido> createState() => _TelaTecidoState();
}

class _TelaTecidoState extends State<TelaTecido> {
  WebViewController? _mobileController;
  webview_windows.WebviewController? _windowsController;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    final htmlString = await rootBundle.loadString('assets/web/viewer.html');

    if (defaultTargetPlatform == TargetPlatform.windows) {
      final controller = webview_windows.WebviewController();
      await controller.initialize();
      await controller.loadStringContent(htmlString);
      setState(() => _windowsController = controller);
    } else {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadHtmlString(htmlString);
      setState(() => _mobileController = controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Builder(builder: (context) {
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
