import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../../di/di.dart'; // Импортируем talker из вашего di.dart
import 'dio.dart';

void setUpDio() {
  // ВАЖНО: Замените на реальный URL из задания или документации API
  dio.options.baseUrl = 'https://api.example.com'; 
  
  // Если API требует токен, добавьте его (иначе эту строку можно удалить)
  dio.options.queryParameters.addAll({
    'api_token': 'ВАШ_ТОКЕН_ЕСЛИ_НУЖЕН',
  });

  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 5);

  // Подключаем логгер, чтобы видеть запросы в консоли
  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: true,
      ),
    ),
  );
}
