import 'package:flutter/material.dart';

/// Transiciones de navegación reutilizables para mantener una
/// experiencia consistente, fluida y profesional en toda la app.
///
/// No modifican el diseño de ninguna pantalla: solo controlan cómo
/// aparece/desaparece cada una al navegar.
class AppPageRoute {
  AppPageRoute._();

  /// Entrada principal (Bienvenida -> Inicio): zoom progresivo +
  /// desplazamiento suave + fade, con una curva fluida y natural.
  /// Pensada para transmitir una experiencia gastronómica premium.
  static PageRouteBuilder<T> premiumEntry<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final scale = Tween<double>(begin: 1.06, end: 1.0).animate(curved);
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(scale: scale, child: child),
          ),
        );
      },
    );
  }

  /// Cambio entre pestañas principales (Inicio <-> Catálogo):
  /// desplazamiento horizontal sutil + fade, sin cortes bruscos.
  /// [toRight] indica si la pantalla nueva entra desde la derecha
  /// (avanzando) o desde la izquierda (retrocediendo).
  static PageRouteBuilder<T> tabSlide<T>(Widget page, {required bool toRight}) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final dx = toRight ? 0.06 : -0.06;
        final slide = Tween<Offset>(
          begin: Offset(dx, 0),
          end: Offset.zero,
        ).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  /// Apertura del detalle de un plato: fade + acercamiento (zoom) suave
  /// sobre el contenido de la pantalla. La foto del plato en sí anima
  /// aparte mediante un `Hero` (ver `dish-image-<nombre>` en el
  /// catálogo y en la pantalla de detalle), dando la sensación de que
  /// la tarjeta se expande hasta convertirse en la ficha completa.
  static PageRouteBuilder<T> dishDetail<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final scale = Tween<double>(begin: 0.94, end: 1.0).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }
}
