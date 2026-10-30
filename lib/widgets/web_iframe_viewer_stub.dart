// Implementación "vacía" para plataformas que no son Web (móvil,
// escritorio). Ahí el visor 3D se muestra con el paquete
// `model_viewer_plus` directamente, así que este widget nunca se usa
// en la práctica, pero debe existir para que el proyecto compile.
import 'package:flutter/material.dart';

class WebIframeViewer extends StatelessWidget {
  final String src;

  const WebIframeViewer({super.key, required this.src});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
