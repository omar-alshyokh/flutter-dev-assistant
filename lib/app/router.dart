import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/service_locator.dart';
import '../features/chat/presentation/bloc/chat_cubit.dart';
import '../features/chat/presentation/pages/chat_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

class AppRouter {
  static const splash = '/';
  static const chat = '/chat';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case chat:
      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ChatCubit>(),
            child: const ChatScreen(),
          ),
        );
    }
  }
}