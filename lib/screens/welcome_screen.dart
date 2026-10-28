import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_logo.dart';
import 'catalog_screen.dart';

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
            'assets/image/welcome.png',
            fit: BoxFit.cover,
          ),

          // Oscurecido para legibilidad del texto
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.45),
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.82),
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
                color: _gold.withOpacity(0.4),
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
                color: _gold.withOpacity(0.4),
              ),
            ),
          ),

          // Contenido
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const AppLogo(),

                  // Espacio flexible: aquí se ve el personaje, que ya viene
                  // incluido en la imagen de fondo "welcome.png".
                  const Expanded(child: SizedBox.shrink()),

                  _buildWelcomeText(),
                  const SizedBox(height: 26),
                  _buildButton(context),
                  const SizedBox(height: 28),
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
          'Sabor Caribe',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 38,
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
        const SizedBox(height: 10),
        Icon(Icons.waves_rounded, color: _gold, size: 20),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _goToCatalog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: const Color(0xFF17323D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Explorar sabores',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  void _goToCatalog(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CatalogScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }
}
