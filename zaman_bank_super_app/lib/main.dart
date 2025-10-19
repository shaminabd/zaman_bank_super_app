import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_notification_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ZamanBankApp());
}

class ZamanBankApp extends StatelessWidget {
  const ZamanBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ChatNotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Zaman Bank',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: const Color(0xFF2D9A86),
          fontFamily: GoogleFonts.inter().fontFamily,
          scaffoldBackgroundColor: const Color(0xFFF3F6F9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF3F6F9),
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
