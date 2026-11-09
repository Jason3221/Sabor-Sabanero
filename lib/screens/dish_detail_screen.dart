import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dish.dart';
import '../utils/page_transitions.dart';
import 'model_3d_screen.dart';

/// Pantalla de detalle de un plato: foto estándar del plato + botón
/// "Ver en 3D" (solo si el plato tiene [Dish.modelAsset]) que abre el
/// visor 3D a pantalla completa en [Model3DScreen], y lista de
/// ingredientes.
class DishDetailScreen extends StatefulWidget {
  final Dish dish;

  const DishDetailScreen({super.key, required this.dish});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  static const _gold = Color(0xFFFFC107);

  void _open3DViewer(Dish dish) {
    Navigator.of(context).push(
      AppPageRoute.fullscreenFade<void>(Model3DScreen(dish: dish)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image/fondoRestaurantee.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.78),
                  Colors.black.withValues(alpha: 0.92),
                ],
                stops: const [0.0, 0.3, 0.65, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context, dish),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      children: [
                        _buildViewer(dish),
                        const SizedBox(height: 24),
                        _buildInfoHeader(dish),
                        const SizedBox(height: 26),
                        _buildIngredients(dish),
                        const SizedBox(height: 26),
                        _buildOrderButton(context, dish),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Dish dish) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          _circleButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Center(
              child: Text(
                dish.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white, size: 19),
          ),
        ),
      ),
    );
  }

  Widget _buildViewer(Dish dish) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 210,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Foto estándar del plato, horizontal y recortada en todo
            // el cuadro. Usa el mismo `Hero` tag que la tarjeta del
            // catálogo para que la imagen "vuele" de una pantalla a
            // la otra al abrir/cerrar el plato.
            Hero(
              tag: 'dish-image-${dish.name}',
              child: Image.asset(dish.imageAsset, fit: BoxFit.cover),
            ),

            // Viñeta sutil para que el botón resalte sobre la foto
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.35],
                ),
              ),
            ),

            if (dish.modelAsset != null)
              Positioned(
                top: 14,
                right: 14,
                child: _View3DButton(onTap: () => _open3DViewer(dish)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoHeader(Dish dish) {
    return Column(
      children: [
        Text(
          dish.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ..._buildStars(dish),
            const SizedBox(width: 6),
            Text(
              dish.ratingValue.toStringAsFixed(1),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${dish.reviews} reseñas)',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          dish.description,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            dish.price,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: const Color(0xFF17323D),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStars(Dish dish) {
    final full = dish.ratingValue.floor();
    final half = (dish.ratingValue - full) >= 0.5;
    final empty = 5 - full - (half ? 1 : 0);
    return [
      for (var i = 0; i < full; i++)
        const Icon(Icons.star_rounded, size: 16, color: _gold),
      if (half) const Icon(Icons.star_half_rounded, size: 16, color: _gold),
      for (var i = 0; i < empty; i++)
        Icon(
          Icons.star_border_rounded,
          size: 16,
          color: _gold.withValues(alpha: 0.7),
        ),
    ];
  }

  Widget _buildIngredients(Dish dish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.restaurant_rounded, color: _gold, size: 18),
            const SizedBox(width: 8),
            Text(
              'Lo que lleva este plato',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.5,
          children:
              dish.ingredients.map((ing) => _buildIngredientChip(ing)).toList(),
        ),
      ],
    );
  }

  Widget _buildIngredientChip(String ingredient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: _gold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ingredient,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderButton(BuildContext context, Dish dish) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Próximamente: ordenar ${dish.name}'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF0D3B4C),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: const Color(0xFF17323D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ordenar este plato',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.shopping_bag_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

/// Botón dorado "Ver en 3D" que se posiciona sobre la foto del plato.
class _View3DButton extends StatelessWidget {
  final VoidCallback onTap;

  const _View3DButton({required this.onTap});

  static const _gold = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.view_in_ar_rounded,
                color: Color(0xFF17323D),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Ver en 3D',
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
    );
  }
}

