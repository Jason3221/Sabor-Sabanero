// Implementación específica de Flutter Web: embebe una página HTML
// (como `web/model_viewer.html`) dentro de un iframe real del navegador,
// usando el mecanismo de "platform views" de Flutter.
//
// Se usa en vez del paquete `model_viewer_plus` para el visor 3D porque
// ese paquete no está generando correctamente el HTML del visor con el
// renderizador web actual de Flutter (el modelo nunca llega a pedirse).
// Esta página HTML ya fue probada por separado y sí funciona.
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

final Set<String> _registeredViewTypes = <String>{};

class WebIframeViewer extends StatelessWidget {
  final String src;

  const WebIframeViewer({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    final viewType = 'web-iframe-viewer-$src';

    if (!_registeredViewTypes.contains(viewType)) {
      _registeredViewTypes.add(viewType);
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        final iframe = html.IFrameElement()
          ..src = src
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allow =
              'xr-spatial-tracking; accelerometer; gyroscope; magnetometer';
        return iframe;
      });
    }

    return HtmlElementView(viewType: viewType);
  }
}
