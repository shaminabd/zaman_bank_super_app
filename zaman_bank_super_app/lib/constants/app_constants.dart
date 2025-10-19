import 'package:flutter/material.dart';

class AppColors {
  // Zaman Color Palette
  static const Color zamanPersianGreen = Color(0xFF2D9A86); // Primary action buttons, icons, headings
  static const Color zamanSolar = Color(0xFFEEFE6D); // Growth and investment buttons
  static const Color zamanCloud = Color(0xFFF3F6F9); // Backgrounds
  
  // Legacy colors for compatibility
  static const Color primaryGreen = Color(0xFF2D9A86);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color teal = Color(0xFF2D9A86);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFF3F6F9);
}

class AppTextStyles {
  static const TextStyle splashTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  
  static const TextStyle splashSubtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
  
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );
}
