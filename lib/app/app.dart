import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'router.dart';
import '../core/theme/app_theme.dart';

class ChatBotApp extends StatelessWidget {
  const ChatBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.main();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WidgetWise',
      theme: theme.copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(theme.textTheme),
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.splash,
    );
  }
}
