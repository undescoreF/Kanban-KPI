import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: AppColors.bgMain,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        surface: AppColors.bgCard,
        onSurface: AppColors.textPrimary,
      ),

      // Typographie
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppColors.textPrimary,
        ),
        // colonnes
        titleMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
        //nom des taches
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        // compteur
        labelSmall: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 10,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}