import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dish.dart';
import '../widgets/bottom_nav.dart';
import 'catalog_screen.dart';

/// Pantalla de Inicio: presentación del restaurante (quiénes somos,
/// cifras, lo que nos hace únicos, carrusel de platos insignia,
/// horario y ubicación) con acceso directo al catálogo completo.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _gold = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/fondoRestaurantee.png', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.75),
                  Colors.black.withValues(alpha: 0.88),
                  Colors.black.withValues(alpha: 0.94),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
              children: [
                _buildHero(),
                const SizedBox(height: 26),
                _buildQuienesSomos(context),
                const SizedBox(height: 22),
                _buildStats(),
                const SizedBox(height: 28),
                _buildUniqueFeatures(),
                const SizedBox(height: 28),
                _buildPrideCarousel(context),
                const SizedBox(height: 28),
                _buildSchedule(),
                const SizedBox(height: 28),
                _buildLocation(context),
                const SizedBox(height: 26),
                _buildMenuButton(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: 0,
        onTap: (i) => _handleNavTap(context, i),
      ),
    );
  }

  void _handleNavTap(BuildContext context, int index) {
    if (index == 0) return;
    if (index == 1) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CatalogScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
      return;
    }
    final labels = {2: 'Favoritos', 3: 'Perfil'};
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Próximamente: ${labels[index]}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0D3B4C),
      ),
    );
  }

  // ---------- Hero ----------

  Widget _buildHero() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 230,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/image/h2.jpg', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.45, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sincinaty Express',
                    style: GoogleFonts.pacifico(
                      color: _gold,
                      fontSize: 30,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SABOR COSTEÑO · DESDE EL CORAZÓN DEL CARIBE',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
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

  // ---------- ¿Quiénes somos? ----------

  Widget _buildQuienesSomos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '¿Quiénes somos?',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _showComingSoon(context, 'más sobre nosotros'),
              child: Text(
                'Leer más',
                style: GoogleFonts.poppins(
                  color: _gold,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Somos un restaurante familiar que cocina lo mejor de la '
          'gastronomía costeña: mote, mojarra, sancocho y arroz de coco, '
          'preparados al momento con ingredientes de la plaza.',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13.5,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: const [
        Expanded(child: _StatCard(value: '+10', label: 'años cocinando')),
        SizedBox(width: 10),
        Expanded(child: _StatCard(value: '25', label: 'platos a la carta')),
        SizedBox(width: 10),
        Expanded(child: _StatCard(value: '100%', label: 'ingredientes frescos')),
      ],
    );
  }

  // ---------- Lo que nos hace únicos ----------

  Widget _buildUniqueFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lo que nos hace únicos',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _FeatureCard(emoji: '🌿', label: 'Ingrediente\nde la plaza'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _FeatureCard(emoji: '👵', label: 'Recetas\nde la abuela'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _FeatureCard(emoji: '🌴', label: 'Sabor\nde la costa'),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- El orgullo de la casa (carrusel) ----------

  Widget _buildPrideCarousel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'El orgullo de la casa',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _PrideCarousel(onCardTap: () => _handleNavTap(context, 1)),
      ],
    );
  }

  // ---------- Horario ----------

  Widget _buildSchedule() {
    const rows = [
      ('Lunes a viernes', '11:00 am – 9:00 pm'),
      ('Sábados', '11:00 am – 10:00 pm'),
      ('Domingos', '12:00 m – 6:00 pm'),
    ];
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horario de atención',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.12)),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rows[i].$1,
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  rows[i].$2,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ---------- Encuéntranos ----------

  Widget _buildLocation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Encuéntranos',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: _gold,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cra 43 #68-90, Barranquilla',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'A dos cuadras de la plaza del mercado',
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _OutlinedPillButton(
                      label: 'Llamar',
                      color: Colors.white54,
                      onTap: () => _showComingSoon(context, 'llamar al restaurante'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _OutlinedPillButton(
                      label: 'WhatsApp',
                      color: Colors.white54,
                      onTap: () => _showComingSoon(context, 'escribir por WhatsApp'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _OutlinedPillButton(
                      label: 'Cómo llegar',
                      color: Colors.white54,
                      onTap: () => _showComingSoon(context, 'cómo llegar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _handleNavTap(context, 1),
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
              'Ver el menú de platos',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 19),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Próximamente: $what'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0D3B4C),
      ),
    );
  }
}

/// Carrusel grande deslizable (una tarjeta a la vez) para mostrar los
/// platos insignia del restaurante, con foto a pantalla completa,
/// insignia de calificación, nombre/precio superpuestos y puntos
/// indicadores de página.
class _PrideCarousel extends StatefulWidget {
  final VoidCallback onCardTap;

  const _PrideCarousel({required this.onCardTap});

  @override
  State<_PrideCarousel> createState() => _PrideCarouselState();
}

class _PrideCarouselState extends State<_PrideCarousel> {
  static const _gold = Color(0xFFFFC107);

  final PageController _controller = PageController(viewportFraction: 0.88);
  int _page = 0;
  Timer? _autoplayTimer;

  @override
  void initState() {
    super.initState();
    _autoplayTimer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
      if (!_controller.hasClients) return;
      final next = (_page + 1) % dishes.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 215,
          child: PageView.builder(
            controller: _controller,
            itemCount: dishes.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) {
              final dish = dishes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: widget.onCardTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(dish.imageAsset, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.25),
                                Colors.black.withValues(alpha: 0.85),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _gold,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 14,
                                  color: Color(0xFF17323D),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  dish.ratingValue.toStringAsFixed(1),
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF17323D),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 18,
                          right: 18,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dish.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dish.price,
                                style: GoogleFonts.poppins(
                                  color: _gold,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(dishes.length, (i) {
            final active = i == _page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? _gold : Colors.white24,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  static const _gold = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              color: _gold,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 11,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String emoji;
  final String label;

  const _FeatureCard({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlinedPillButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OutlinedPillButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.6)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta reutilizable con efecto de vidrio esmerilado, acorde al resto
/// de la app.
class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: child,
        ),
      ),
    );
  }
}
