import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../models/dish.dart';
import '../widgets/web_iframe_viewer.dart';

/// Visor 3D a pantalla completa: fondo transparente/oscuro liso (sin la
/// foto del restaurante ni ningún otro elemento), el modelo ocupando
/// todo el espacio disponible y una flecha para volver atrás. Se abre
/// desde el botón "Ver en 3D" de [DishDetailScreen] cuando el plato
/// tiene [Dish.modelAsset].
class Model3DScreen extends StatelessWidget {
  final Dish dish;

  const Model3DScreen({super.key, required this.dish});

  static const _gold = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    final modelFile = dish.modelAsset;
    final webSrc = 'models/$modelFile';
    final assetSrc = 'assets/models/$modelFile';

    return Scaffold(
      // Fondo liso y oscuro (sin imagen ni degradado) para que todo el
      // protagonismo sea del modelo 3D, que ya se renderiza con fondo
      // transparente tanto en Web como en móvil/escritorio.
      backgroundColor: Colors.black,
      // IMPORTANTE: la barra superior (flecha + nombre) va en un
      // `Column` separado del visor, nunca superpuesta encima de él.
      // En Web el visor es un <iframe> real (ver `WebIframeViewer`) y
      // un elemento real del navegador "se come" los toques aunque un
      // widget de Flutter se pinte visualmente encima — por eso antes
      // la flecha no respondía. Al no solaparse, siempre queda en
      // territorio 100% de Flutter y responde al toque.
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  _circleButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dish.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  modelFile == null
                      ? const SizedBox.shrink()
                      : kIsWeb
                          ? WebIframeViewer(
                              src: 'model_viewer.html?src='
                                  '${Uri.encodeComponent(webSrc)}',
                            )
                          : ModelViewer(
                              backgroundColor: Colors.transparent,
                              src: assetSrc,
                              alt: 'Modelo 3D de ${dish.name}',
                              autoRotate: true,
                              autoRotateDelay: 0,
                              rotationPerSecond: '18deg',
                              cameraControls: true,
                              disableZoom: false,
                              ar: false,
                            ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 18,
                    child: IgnorePointer(
                      child: Center(
                        child: Text(
                          'Arrastra para girar el modelo · pellizca para zoom',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.black.withValues(alpha: 0.4),
          shape: CircleBorder(
            side: BorderSide(color: _gold.withValues(alpha: 0.4)),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 42,
              height: 42,
              child: Icon(icon, color: _gold, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
