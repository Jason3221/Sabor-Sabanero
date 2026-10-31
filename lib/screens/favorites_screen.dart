import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dish.dart';
import '../utils/page_transitions.dart';
import '../widgets/bottom_nav.dart';
import 'catalog_screen.dart';
import 'home_screen.dart';

/// Pantalla "Los más queridos": historias de quién marcó qué como
/// favorito, el plato más favorito destacado y un ranking de la casa.
/// Todos los datos de actividad (personas, conteos) son simulados
/// mientras no haya cuentas de usuario reales.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  static const _gold = Color(0xFFFFC107);

  // El usuario "actual" ya tiene marcado como favorito el plato más
  // querido, para que el corazón se sienta consistente con el resto
  // de la app (dato simulado, igual que el resto de esta pantalla).
  final Set<String> _myFavorites = {'Mote de Queso'};

  Dish get _topFavorite =>
      dishes.reduce((a, b) => a.favoritesCount > b.favoritesCount ? a : b);

  List<Dish> get _ranking {
    final sorted = [...dishes]
      ..sort((a, b) => b.favoritesCount.compareTo(a.favoritesCount));
    return sorted;
  }

  void _toggleFavorite(String dishName) {
    setState(() {
      if (_myFavorites.contains(dishName)) {
        _myFavorites.remove(dishName);
      } else {
        _myFavorites.add(dishName);
      }
    });
  }

  void _openStory(int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) =>
            _StoryOverlay(initialIndex: initialIndex),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _handleNavTap(BuildContext context, int index) {
    if (index == 2) return;
    if (index == 0) {
      Navigator.of(context).push(
        AppPageRoute.tabSlide<void>(const HomeScreen(), toRight: false),
      );
      return;
    }
    if (index == 1) {
      Navigator.of(context).push(
        AppPageRoute.tabSlide<void>(const CatalogScreen(), toRight: false),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Próximamente: Perfil'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF0D3B4C),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/fondoRestaurantee.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.78),
                  Colors.black.withValues(alpha: 0.62),
                  Colors.black.withValues(alpha: 0.78),
                  Colors.black.withValues(alpha: 0.95),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 110),
              children: [
                _buildHeader(),
                const SizedBox(height: 18),
                _buildStoriesRow(),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFeaturedCard(context),
                      const SizedBox(height: 26),
                      _buildRankingHeader(),
                      const SizedBox(height: 12),
                      ..._ranking.asMap().entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _RankingTile(
                                rank: entry.key + 1,
                                dish: entry.value,
                                isFavorite:
                                    _myFavorites.contains(entry.value.name),
                                onToggleFavorite: () =>
                                    _toggleFavorite(entry.value.name),
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
      bottomNavigationBar: BottomNav(
        selectedIndex: 2,
        onTap: (i) => _handleNavTap(context, i),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Los más ',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'queridos',
                  style: GoogleFonts.poppins(
                    color: _gold,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lo que la gente más ama de Sincinaty',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesRow() {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: favoriteActivities.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final activity = favoriteActivities[index];
          return GestureDetector(
            onTap: () => _openStory(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _gold, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(activity.avatarColorValue),
                    child: Text(
                      activity.personName[0],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  activity.personName,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context) {
    final dish = _topFavorite;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Image.asset(
            dish.imageAsset,
            height: 230,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: 230,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _gold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 6),
                  Text(
                    'El más favorito',
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
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded,
                        color: Colors.redAccent, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      '${dish.favoritesCount} personas lo aman',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.star_rounded, color: _gold, size: 15),
                    const SizedBox(width: 3),
                    Text(
                      dish.ratingValue.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingHeader() {
    return Row(
      children: [
        Text(
          'Ranking de la casa',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        const Text('🏆', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

class _RankingTile extends StatelessWidget {
  final int rank;
  final Dish dish;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _RankingTile({
    required this.rank,
    required this.dish,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  static const _gold = Color(0xFFFFC107);

  Color get _rankColor {
    switch (rank) {
      case 1:
        return _gold;
      case 2:
        return const Color(0xFFD7D7D7);
      case 3:
        return const Color(0xFFCD8A4E);
      default:
        return Colors.white24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.32),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _rankColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$rank',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF17323D),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  dish.imageAsset,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.favorite_rounded,
                            color: Colors.redAccent, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${dish.favoritesCount} favoritos',
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onToggleFavorite,
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite ? Colors.redAccent : Colors.white54,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vista estilo "historias" (como Instagram) que muestra, una por una,
/// a cada persona simulada marcando un plato como favorito. Avanza
/// sola con una barra de progreso segmentada; se puede tocar a los
/// lados para ir adelante/atrás o la X para cerrar.
class _StoryOverlay extends StatefulWidget {
  final int initialIndex;

  const _StoryOverlay({required this.initialIndex});

  @override
  State<_StoryOverlay> createState() => _StoryOverlayState();
}

class _StoryOverlayState extends State<_StoryOverlay>
    with SingleTickerProviderStateMixin {
  static const _gold = Color(0xFFFFC107);
  static const _storyDuration = Duration(milliseconds: 3000);

  late int _index;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = AnimationController(vsync: this, duration: _storyDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _next();
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Dish _dishFor(FavoriteActivity activity) =>
      dishes.firstWhere((d) => d.name == activity.dishName);

  void _next() {
    if (_index >= favoriteActivities.length - 1) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _index++);
    _controller.forward(from: 0);
  }

  void _previous() {
    if (_index <= 0) {
      _controller.forward(from: 0);
      return;
    }
    setState(() => _index--);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final activity = favoriteActivities[_index];
    final dish = _dishFor(activity);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Image.asset(
                  dish.imageAsset,
                  key: ValueKey(dish.imageAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
            ),

            // Zonas táctiles invisibles: izquierda = anterior,
            // derecha = siguiente.
            Row(
              children: [
                Expanded(child: GestureDetector(onTap: _previous)),
                Expanded(child: GestureDetector(onTap: _next)),
              ],
            ),

            Positioned(
              top: 8,
              left: 14,
              right: 14,
              child: Row(
                children: List.generate(favoriteActivities.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 3,
                          child: i < _index
                              ? const ColoredBox(color: _gold)
                              : i > _index
                                  ? ColoredBox(
                                      color:
                                          Colors.white.withValues(alpha: 0.3))
                                  : AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, _) =>
                                          LinearProgressIndicator(
                                        value: _controller.value,
                                        backgroundColor:
                                            Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                _gold),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Positioned(
              top: 24,
              left: 14,
              right: 14,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(activity.avatarColorValue),
                    child: Text(
                      activity.personName[0],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.personName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          activity.timeAgo,
                          style: GoogleFonts.poppins(
                            color: Colors.white60,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 26),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 24,
              right: 24,
              bottom: 40,
              child: IgnorePointer(
                child: Column(
                  children: [
                    Text(
                      dish.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '♥ ${activity.personName} lo marcó como favorito',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.redAccent,
                        fontSize: 13.5,
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
    );
  }
}
