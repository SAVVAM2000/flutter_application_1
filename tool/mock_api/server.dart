// Локальный тестовый API для запуска приложения без внешнего сервера.
//
// Запуск из папки проекта:
//   dart run tool/mock_api/server.dart
// или двойным щелчком по start.bat (Windows).
//
// Отдаёт те же адреса, что ждёт приложение:
//   GET /content        — список элементов
//   GET /content/{id}   — один элемент
//   GET /images/*.jpg   — картинки для карточек
import 'dart:convert';
import 'dart:io';

const int _port = 8765;

final List<Map<String, Object>> _items = [
  {
    'id': 1,
    'title': 'Самурай',
    'author': 'Маличкин С.В.',
    'description':
        'Самурай — воин-феодал в Японии, служивший своему господину и получавший '
            'за службу землю или рисовый паёк.\n\n'
            'Жизнь воина регулировал кодекс бусидо — «путь воина». Он требовал '
            'верности, чести и готовности отдать жизнь за господина.\n\n'
            'Сословие самураев просуществовало почти семь столетий и было '
            'упразднено в 1876 году, когда в Японии запретили носить мечи.',
    'image': 'http://127.0.0.1:$_port/images/samurai.jpg',
  },
  {
    'id': 2,
    'title': 'Киото',
    'author': 'Маличкин С.В.',
    'description':
        'Киото был столицей Японии с 794 по 1868 год и носил имя Хэйан-кё — '
            '«столица мира и спокойствия».\n\n'
            'Город не пострадал от бомбардировок Второй мировой войны, поэтому '
            'историческая застройка сохранилась почти полностью.\n\n'
            'В 1994 году 17 объектов Киото включили в список Всемирного наследия '
            'ЮНЕСКО.',
    'image': 'http://127.0.0.1:$_port/images/kyoto.jpg',
  },
  {
    'id': 3,
    'title': 'Фусими Инари',
    'author': 'Маличкин С.В.',
    'description':
        'Фусими Инари — главное святилище божества Инари, покровителя риса и '
            'торговли. Оно основано в 711 году.\n\n'
            'Святилище знаменито тоннелями из ворот-тории: каждые ворота подарены '
            'компанией или семьёй, а на обратной стороне написано имя дарителя.\n\n'
            'Длина маршрута по горе — около четырёх километров, вход свободный '
            'и круглосуточный.',
    'image': 'http://127.0.0.1:$_port/images/fushimi.jpg',
  },
  {
    'id': 4,
    'title': 'Гора Фудзи',
    'author': 'Маличкин С.В.',
    'description':
        'Фудзияма — действующий вулкан высотой 3776 метров, самая высокая точка '
            'Японии. Последнее извержение было в 1707 году.\n\n'
            'Гора имеет почти идеально симметричный конус и служит символом страны. '
            'Сезон восхождений длится с июля по сентябрь.\n\n'
            'В 2013 году Фудзи включили в список Всемирного наследия ЮНЕСКО как '
            'культурный объект.',
    'image': 'http://127.0.0.1:$_port/images/fuji.jpg',
  },
];

Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, _port);
  stdout.writeln('Тестовый API запущен: http://127.0.0.1:$_port/content');
  stdout.writeln('Остановить: Ctrl+C');
  await for (final request in server) {
    await _handle(request);
  }
}

Future<void> _handle(HttpRequest request) async {
  final response = request.response;
  response.headers.set('Access-Control-Allow-Origin', '*');
  response.headers.set('Access-Control-Allow-Headers', '*');

  if (request.method == 'OPTIONS') {
    response.statusCode = HttpStatus.noContent;
    await response.close();
    return;
  }

  final path = request.uri.path;

  if (path == '/content') {
    await _json(response, {'data': _items});
    return;
  }

  if (path.startsWith('/content/')) {
    final id = int.tryParse(path.substring('/content/'.length));
    for (final item in _items) {
      if (item['id'] == id) {
        await _json(response, {'data': item});
        return;
      }
    }
    await _json(response, {'error': 'not found'}, status: HttpStatus.notFound);
    return;
  }

  if (path.startsWith('/images/')) {
    final file = File.fromUri(
      Platform.script.resolve('images/${path.substring('/images/'.length)}'),
    );
    if (file.existsSync()) {
      response.headers.contentType = ContentType('image', 'jpeg');
      await response.addStream(file.openRead());
      await response.close();
      return;
    }
  }

  await _json(response, {'error': 'not found'}, status: HttpStatus.notFound);
}

Future<void> _json(
  HttpResponse response,
  Object payload, {
  int status = HttpStatus.ok,
}) async {
  response.statusCode = status;
  response.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
  response.write(jsonEncode(payload));
  await response.close();
}
