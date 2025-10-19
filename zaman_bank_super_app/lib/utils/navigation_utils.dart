import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class NavigationUtils {
  // Safe back navigation that handles empty navigation stack
  static void safePop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // If no previous page, navigate to home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // Navigate to home screen
  static void goToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  // Navigate with proper back handling
  static Future<T?> navigateWithBack<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
