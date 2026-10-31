import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/page_transitions.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _gold = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo: interior del restaurante
          Image.asset(
            'assets/image/welcome.jpg',
            fit: BoxFit.cover,
          ),

          // Oscurecido para legibilidad del texto
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.45),
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.82),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Decoración: oleadas doradas en las esquinas inferiores
          Positioned(
            left: -12,
            bottom: 130,
            child: Transform.rotate(
              angle: -0.25,
              child: Icon(
                Icons.waves_rounded,
                size: 70,
                color: _gold.withValues(alpha: 0.4),
              ),
            ),
          ),
          Positioned(
            right: -12,
            bottom: 130,
            child: Transform.rotate(
              angle: 0.25,
              child: Icon(
                Icons.waves_rounded,
                size: 70,
                color: _gold.withValues(alpha: 0.4),
              ),
            ),
          ),

          // Contenido
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  // Espacio flexible: el logo y el personaje ya vienen
                  // incluidos en la imagen de fondo "sinsinaty.png".
                  const Expanded(child: SizedBox.shrink()),

                  _buildWelcomeText(),
                  const SizedBox(height: 22),
                  _buildButton(context),
                  const SizedBox(height: 38),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '〉〉',
              style: GoogleFonts.dancingScript(
                color: _gold,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '¡Bienvenido a',
              style: GoogleFonts.dancingScript(
                color: _gold,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '〈〈',
              style: GoogleFonts.dancingScript(
                color: _gold,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Sincinaty Express',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Descubre los sabores auténticos\nde nuestra costa, en cada plato.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _goToHome(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: const Color(0xFF17323D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: Text(
          'Explorar sabores',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _goToHome(BuildContext context) {
    Navigator.of(context).push(
      AppPageRoute.premiumEntry<void>(const HomeScreen()),
    );
  }
}
