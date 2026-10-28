import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Dibuja la app de borde a borde (sin barra blanca arriba/abajo
  // cuando se corre en un celular real).
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SaborCaribeApp());
}

class SaborCaribeApp extends StatelessWidget {
  const SaborCaribeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sabor Caribe',
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
