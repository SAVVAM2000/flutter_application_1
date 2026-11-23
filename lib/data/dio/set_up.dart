import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../../di/di.dart'; // Импортируем talker из вашего di.dart
import 'dio.dart';

void setUpDio() {
  // Сейчас адрес указывает на локальный тестовый API (tool/mock_api/server.dart).
  // Когда появится адрес API из задания, замените его здесь.
  dio.options.baseUrl = 'http://127.0.0.1:8765';

  // Если API требует токен, впишите его вместо заглушки, иначе удалите блок
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
