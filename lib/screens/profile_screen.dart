import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/page_transitions.dart';
import '../widgets/bottom_nav.dart';
import 'catalog_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';

/// Pantalla de Perfil: datos del cliente, cifras de su relación con el
/// restaurante y accesos a pedidos, direcciones, pagos y ayuda. Es un
/// diseño exploratorio con datos simulados mientras no haya cuentas de
/// usuario reales.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _gold = Color(0xFFFFC107);

  void _handleNavTap(BuildContext context, int index) {
    if (index == 3) return;
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
    Navigator.of(context).push(
      AppPageRoute.tabSlide<void>(const FavoritesScreen(), toRight: false),
    );
  }

  void _showComingSoon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Próximamente: $what'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0D3B4C),
      ),
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF17323D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            '¿Cerrar sesión?',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Vas a salir de tu cuenta de Sincinaty Express.',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showComingSoon('cerrar sesión');
              },
              child: Text(
                'Cerrar sesión',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFE57373),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              children: [
                _buildHeader(context),
                const SizedBox(height: 26),
                _buildAvatarCard(context),
                const SizedBox(height: 22),
                _buildStats(),
                const SizedBox(height: 26),
                _buildMenuSection(context),
                const SizedBox(height: 26),
                _buildSignOutButton(context),
                const SizedBox(height: 18),
                Center(
                  child: Text(
                    'Sincinaty Express · v1.0.0',
                    style: GoogleFonts.poppins(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: 3,
        onTap: (i) => _handleNavTap(context, i),
      ),
    );
  }

  // ---------- Encabezado ----------

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              children: const [
                TextSpan(text: 'Mi ', style: TextStyle(color: Colors.white)),
                TextSpan(text: 'perfil', style: TextStyle(color: _gold)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _showComingSoon('editar perfil'),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: Colors.white70,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Tarjeta de avatar ----------

  Widget _buildAvatarCard(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_gold, Color(0xFFB8860B)],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'J',
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFF17323D),
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jason Ruiz',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'jesusdavidruiztrivi@gmail.com',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: _gold,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Cliente desde 2024',
                        style: GoogleFonts.poppins(
                          color: _gold,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
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
    );
  }

  // ---------- Cifras ----------

  Widget _buildStats() {
    return const Row(
      children: [
        Expanded(child: _StatCard(value: '12', label: 'pedidos\nrealizados')),
        SizedBox(width: 10),
        Expanded(child: _StatCard(value: '5', label: 'platos\nfavoritos')),
        SizedBox(width: 10),
        Expanded(child: _StatCard(value: '4.9', label: 'calificación\npromedio')),
      ],
    );
  }

  // ---------- Menú de opciones ----------

  Widget _buildMenuSection(BuildContext context) {
    final items = [
      (Icons.receipt_long_rounded, 'Mis pedidos', 'mis pedidos'),
      (Icons.location_on_outlined, 'Direcciones guardadas', 'direcciones guardadas'),
      (Icons.credit_card_rounded, 'Métodos de pago', 'métodos de pago'),
      (Icons.notifications_none_rounded, 'Notificaciones', 'notificaciones'),
      (Icons.help_outline_rounded, 'Ayuda y soporte', 'ayuda y soporte'),
    ];
    return _GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _MenuTile(
              icon: items[i].$1,
              label: items[i].$2,
              onTap: () => _showComingSoon(items[i].$3),
            ),
            if (i < items.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Divider(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ---------- Cerrar sesión ----------

  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _confirmSignOut,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE57373)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Color(0xFFE57373),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Cerrar sesión',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE57373),
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fila de un ítem del menú de perfil (icono, etiqueta y flecha).
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  static const _gold = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: _gold, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white38,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tarjeta pequeña de una cifra (valor destacado en dorado + etiqueta).
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
