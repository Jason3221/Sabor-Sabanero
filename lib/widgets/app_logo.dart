import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Logotipo de texto de Sinsinaty Express: solo el nombre del restaurante
/// y el subtítulo "GASTRONOMÍA COSTEÑA", sin iconos adicionales, para un
/// look limpio que combina con el logo ya incluido en las fotos de fondo.
class AppLogo extends StatelessWidget {
  final double titleSize;

  const AppLogo({super.key, this.titleSize = 28});

  static const _gold = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sincinaty Express',
          textAlign: TextAlign.center,
          style: GoogleFonts.pacifico(
            fontSize: titleSize,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'GASTRONOMÍA COSTEÑA',
          style: GoogleFonts.poppins(
            color: _gold,
            fontSize: titleSize * 0.38,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
