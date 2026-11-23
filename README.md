# flutter_application_1

Лабораторные работы 3–6: вёрстка, API, BLoC и Firebase.

## Запуск

Приложение берёт карточки из API (`baseUrl` — в `lib/data/dio/set_up.dart`), а вход и
профиль пользователя — из Firebase. Пока внешнего API нет, в проекте есть локальный
тестовый сервер с теми же адресами.

1. Запустить тестовый API — в одном терминале из папки проекта:

   ```
   dart run tool/mock_api/server.dart
   ```

   (на Windows можно просто открыть `tool/mock_api/start.bat`)

2. Запустить приложение — во втором терминале:

   ```
   flutter run -d chrome
   ```

Firebase Authentication и Cloud Firestore не поддерживают Windows-десктоп, поэтому
приложение запускается в браузере (или на Android/iOS). При первом запуске откройте
экран входа и зарегистрируйтесь по почте и паролю — профиль сохранится в Cloud Firestore.

## Firebase

Проект: `flutter-lab6-36672`. Настройки веб-приложения лежат в `lib/firebase_options.dart`
(сгенерирован FlutterFire CLI), правила доступа к базе — в `firestore.rules`
(заливаются командой `firebase deploy --only firestore:rules`).
