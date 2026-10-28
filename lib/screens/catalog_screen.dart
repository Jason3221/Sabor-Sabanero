import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dish.dart';
import '../widgets/app_logo.dart';
import 'dish_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const _gold = Color(0xFFFFC107);
  static const _lightBlue = Color(0xFF6FD6E8);

  String _selectedCategory = 'Todos';
  final Set<String> _favorites = {};

  List<Dish> get _filteredDishes {
    return dishes.where((dish) {
      return _selectedCategory == 'Todos' || dish.category == _selectedCategory;
    }).toList();
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Sopas':
        return Icons.ramen_dining_rounded;
      case 'Pescados':
        return Icons.set_meal_rounded;
      case 'Carnes':
        return Icons.kebab_dining_rounded;
      case 'Tradicionales':
        return Icons.soup_kitchen_rounded;
      default:
        return Icons.dinner_dining_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo: foto del restaurante
          Image.asset(
            'assets/image/fondoRestaurantee.png',
            fit: BoxFit.cover,
          ),

          // Oscurecido para que el texto resalte
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.85),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Contenido: todo en una sola lista desplazable, así el
          // encabezado (logo + "Nuestro Menú") se desliza y desaparece
          // junto con el resto al bajar, dejando más espacio para los platos.
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 110),
              children: [
                _buildHeaderWithLogo(context),
                const SizedBox(height: 18),
                _buildTitleBlock(),
                const SizedBox(height: 18),
                _buildCategoryChips(),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ..._filteredDishes.map((dish) => _DishCard(
                            dish: dish,
                            isFavorite: _favorites.contains(dish.name),
                            onToggleFavorite: () {
                              setState(() {
                                if (_favorites.contains(dish.name)) {
                                  _favorites.remove(dish.name);
                                } else {
                                  _favorites.add(dish.name);
                                }
                              });
                            },
                          )),
                      if (_filteredDishes.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(
                              'No encontramos platos con ese nombre',
                              style: GoogleFonts.poppins(color: Colors.white70),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  /// Flecha de regreso en su propia fila (arriba del logo, a la
  /// izquierda), sin superponerse al texto "Sabor Caribe".
  Widget _buildHeaderWithLogo(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: _circleButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const AppLogo(titleSize: 28),
      ],
    );
  }

  Widget _buildTitleBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explora y disfruta',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Nuestro ',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Menú',
                  style: GoogleFonts.poppins(
                    color: _gold,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Los mejores sabores de la costa\nen un solo lugar',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '〜',
            style: GoogleFonts.poppins(
              color: _lightBlue,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: selected ? _gold : Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? _gold : Colors.white24,
                    ),
                  ),
                  child: Icon(
                    _iconForCategory(cat),
                    color: selected ? const Color(0xFF17323D) : Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat,
                  style: GoogleFonts.poppins(
                    color: selected ? _gold : Colors.white70,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final items = <_NavItem>[
      _NavItem(icon: Icons.home_rounded, label: 'Inicio'),
      _NavItem(icon: Icons.dinner_dining_rounded, label: 'Catálogo'),
      _NavItem(icon: Icons.favorite_border_rounded, label: 'Favoritos'),
      _NavItem(icon: Icons.person_outline_rounded, label: 'Perfil'),
    ];

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.only(
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 10,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            border: const Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == 1; // "Catálogo" activo
              final item = items[i];
              return GestureDetector(
                onTap: () {
                  if (!selected) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Próximamente: ${item.label}'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF0D3B4C),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: selected ? _gold : Colors.white70,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: selected ? _gold : Colors.white70,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (selected)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        width: 18,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: _gold,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}

class _DishCard extends StatelessWidget {
  final Dish dish;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _DishCard({
    required this.dish,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  static const _gold = Color(0xFFFFC107);

  List<Widget> _buildStars() {
    final full = dish.ratingValue.floor();
    final half = (dish.ratingValue - full) >= 0.5;
    final empty = 5 - full - (half ? 1 : 0);
    return [
      for (var i = 0; i < full; i++)
        const Icon(Icons.star_rounded, size: 15, color: _gold),
      if (half) const Icon(Icons.star_half_rounded, size: 15, color: _gold),
      for (var i = 0; i < empty; i++)
        Icon(Icons.star_border_rounded, size: 15, color: _gold.withOpacity(0.7)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DishDetailScreen(dish: dish),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final fade = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        );
                        final scale = Tween<double>(begin: 0.94, end: 1.0)
                            .animate(fade);
                        return FadeTransition(
                          opacity: fade,
                          child: ScaleTransition(scale: scale, child: child),
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          dish.imageAsset,
                          width: 92,
                          height: 112,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dish.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: onToggleFavorite,
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    size: 20,
                                    color: isFavorite ? _gold : Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                ..._buildStars(),
                                const SizedBox(width: 6),
                                Text(
                                  dish.ratingValue.toStringAsFixed(1),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${dish.reviews})',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dish.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white60,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _gold,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    dish.price,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: const Color(0xFF17323D),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white54,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
