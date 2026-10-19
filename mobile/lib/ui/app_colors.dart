import 'package:flutter/material.dart';

/// Paleta compartida con el frontend web (azul marino sobrio + acento azul).
class AppColors {
  // Constructor privado para evitar instancias
  AppColors._();

  // --- COLORES PRINCIPALES ---
  static const Color primary = Color(0xFF1F3A68); // Azul marino
  static const Color secondary = Color(0xFF3566C9); // Azul de acento

  // --- VARIANTES DE MARCA ---
  static const Color primaryLight = Color(0xFF35528A);
  static const Color primaryDark = Color(0xFF14264A);
  static const Color primaryTint = Color(0xFFEAEFF8); // Fondo suave para selección

  // --- ESCALA DE GRISES (fríos, para combinar con el azul) ---
  static const Color black = Color(0xFF111827);
  static const Color greyDark = Color(0xFF4B5565);
  static const Color grey = Color(0xFF7A8394);
  static const Color greyLight = Color(0xFFCBD1DC);
  static const Color greyExtraLight = Color(0xFFF3F5F9);
  static const Color white = Color(0xFFFFFFFF);

  // --- COLORES DE ESTADO (Feedback) ---
  static const Color error = Color(0xFFB42318);
  static const Color success = Color(0xFF1B7F4B);
  static const Color warning = Color(0xFFB7791F);
  static const Color info = Color(0xFF3566C9);

  // --- SUPERFICIES Y FONDOS ---
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4E7EE);
}
