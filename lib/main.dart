import 'package:flutter/material.dart';

import 'core/config/env.dart';
import 'core/di/service_locator.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.load();
  await setupServiceLocator();

  runApp(const ChatBotApp());
}