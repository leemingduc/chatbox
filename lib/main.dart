import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const CareerGuidanceApp());
}

class CareerGuidanceApp extends StatefulWidget {
  const CareerGuidanceApp({super.key});

  @override
  State<CareerGuidanceApp> createState() => _CareerGuidanceAppState();
}

class _CareerGuidanceAppState extends State<CareerGuidanceApp> {
  Locale _locale = const Locale('vi'); // Default language: Vietnamese

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Guidance Chatbox',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('vi'), // Vietnamese
        Locale('en'), // English
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      // SplashScreen is the entry point; it transitions to ChatScreen
      home: SplashScreen(
        onComplete: () {},
        locale: _locale,
        onLanguageChanged: _setLocale,
        buildChatScreen: () => ChatScreen(
          currentLocale: _locale,
          onLanguageChanged: _setLocale,
        ),
      ),
    );
  }
}
