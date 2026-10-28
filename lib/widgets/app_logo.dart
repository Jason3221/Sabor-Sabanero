import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palm_tree_icon.dart';

/// Logo de Sabor Caribe reutilizable: palmera + nombre + ondita + subtítulo.
/// Se usa tanto en la bienvenida como en el catálogo para mantener
/// consistencia visual.
class AppLogo extends StatelessWidget {
  final double titleSize;

  const AppLogo({super.key, this.titleSize = 28});

  static const _gold = Color(0xFFFFC107);
  static const _lightBlue = Color(0xFF6FD6E8);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PalmTreeIcon(size: titleSize * 1.15),
        // Pequeño solape hacia el texto, como si la palmera "coronara"
        // la unión entre "Sabor" y "Caribe".
        Transform.translate(
          offset: Offset(0, -titleSize * 0.12),
          child: Text(
            'Sabor Caribe',
            style: GoogleFonts.pacifico(
              fontSize: titleSize,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 2),
        const Icon(Icons.waves_rounded, color: _lightBlue, size: 18),
        const SizedBox(height: 6),
        Text(
          'GASTRONOMÍA COSTEÑA',
          style: GoogleFonts.poppins(
            color: _gold,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
