import 'dart:math' as math;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_windows/webview_windows.dart' as webview_windows;
import 'package:webview_flutter/webview_flutter.dart' show WebViewController;
import 'package:app_pii/components/viewer.dart';
import 'package:app_pii/components/barra_ferramentas.dart';

class FullscreenViewerPage extends StatefulWidget {
  final String tileSource;
  const FullscreenViewerPage({super.key, required this.tileSource});

  @override
  State<FullscreenViewerPage> createState() => _FullscreenViewerPageState();
}

class _FullscreenViewerPageState extends State<FullscreenViewerPage> {
  WebViewController? _mobileController;
  webview_windows.WebviewController? _windowsController;

  double _zoom = 1.0;
  final double _minZoom = 0.1;
  final double _maxZoom = 100.0;
  bool get _controllersReady => _mobileController != null || _windowsController != null;

  @override
  void initState() {
    super.initState();
    //  Entra em modo landscape
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _windowsController?.dispose();
    super.dispose();
  }

  double _sliderToZoom(double s) {
    return _minZoom * math.pow(_maxZoom / _minZoom, s);
  }

  double _zoomToSlider(double z) {
    return math.log(z / _minZoom) / math.log(_maxZoom / _minZoom);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        left: false, right: false, bottom: false,
        child: Column(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: BarraFerramentas(
                      initialSlider: _zoomToSlider(_zoom),
                      controllersReady: _controllersReady,
                      sliderWidth: 280,
                      onApplyZoom: (z) => _applyZoom(z),
                      onChanged: (s) {
                        setState(() {
                          _zoom = _sliderToZoom(s);
                        });
                      },
                    ),
                  ),
                  Container(width: 1, height: double.infinity, color: Colors.grey[300]),
                  const SizedBox(width: 1),
                  Container(
                    color: Colors.grey[300],
                    height: double.infinity,
                    child: IconButton(
                      icon: const Icon(Icons.fullscreen_exit),
                      color: const Color(0xFF38853A),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 64, minHeight: 56),
                      onPressed: () => Navigator.of(context).maybePop(),
                      tooltip: 'Minimizar',
                    ),
                  ),
                ],
              ),
            ),
 
             // Viewer
             Expanded(
               child: Viewer(
                 tileSource: widget.tileSource,
                 onWebViewCreated: (mobile, windows) {
                   setState(() {
                     _mobileController = mobile;
                     _windowsController = windows;
                   });
                 },
               ),
             ),
           ],
         ),
       ),
     );
   }
} 
