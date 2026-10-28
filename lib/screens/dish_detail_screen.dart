import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dish.dart';

/// Pantalla de detalle de un plato: visor "3D" interactivo (gira con el
/// dedo, pellizca para zoom) + lista de ingredientes.
///
/// Nota: este visor simula profundidad rotando y escalando la foto del
/// plato con transformaciones 3D (Matrix4 + perspectiva). No es un
/// modelo 3D real (.glb/.gltf) — cuando existan esos archivos, se puede
/// reemplazar fácilmente por un paquete como model_viewer_plus.
class DishDetailScreen extends StatefulWidget {
  final Dish dish;

  const DishDetailScreen({super.key, required this.dish});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  static const _gold = Color(0xFFFFC107);

  double _scale = 1.0;
  double _baseScale = 1.0;
  double _rotX = 0.08;
  double _rotY = -0.2;

  void _resetView() {
    setState(() {
      _scale = 1.0;
      _rotX = 0.08;
      _rotY = -0.2;
    });
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
            'assets/image/fondoRestaurantee.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.78),
                  Colors.black.withOpacity(0.92),
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
                        const SizedBox(height: 8),
                        Text(
                          'Arrastra para girar  •  Pellizca para zoom',
                          style: GoogleFonts.poppins(
                            color: Colors.white38,
                            fontSize: 11.5,
                          ),
                        ),
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
          _circleButton(icon: Icons.refresh_rounded, onTap: _resetView),
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
              color: Colors.black.withOpacity(0.35),
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
    return GestureDetector(
      onScaleStart: (details) => _baseScale = _scale,
      onScaleUpdate: (details) {
        setState(() {
          _scale = (_baseScale * details.scale).clamp(0.7, 2.2);
          _rotY =
              (_rotY + details.focalPointDelta.dx * 0.012).clamp(-1.2, 1.2);
          _rotX =
              (_rotX - details.focalPointDelta.dy * 0.012).clamp(-0.6, 0.6);
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: 340,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
              color: Colors.black.withOpacity(0.25),
              gradient: RadialGradient(
                radius: 0.95,
                colors: [
                  _gold.withOpacity(0.16),
                  Colors.transparent,
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Sombra dinámica debajo del plato
                Positioned(
                  bottom: 40,
                  child: Transform.translate(
                    offset: Offset(_rotY * 46, 0),
                    child: Container(
                      width: 170 * _scale,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: RadialGradient(
                          colors: [
                            Colors.black.withOpacity(0.55),
                            Colors.black.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Imagen del plato con transformación 3D
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0015)
                    ..rotateX(_rotX)
                    ..rotateY(_rotY)
                    ..scale(_scale),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        dish.imageAsset,
                        width: 230,
                        height: 230,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _gold.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.threesixty_rounded,
                          color: _gold,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Vista 3D',
                          style: GoogleFonts.poppins(
                            color: _gold,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          color: _gold.withOpacity(0.7),
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
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.7,
          children:
              dish.ingredients.map((ing) => _buildIngredientChip(ing)).toList(),
        ),
      ],
    );
  }

  Widget _buildIngredientChip(String ingredient) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              const Icon(Icons.eco_rounded, color: _gold, size: 15),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ingredient,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
        ),
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
