import 'package:flutter/material.dart';
import 'di/di.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(); // Инициализируем GetIt логгер из di.dart

  FlutterError.onError = (details) {
    return talker.handle(details.exception, details.stack);
  };

  runApp(const AppName());
}
