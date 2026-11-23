import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app.dart';

/// Второй экран приложения — детальная информация об элементе списка.
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.item});

  final ContentItem item;

  @override
  Widget build(BuildContext context) {
    // Задаем фиксированные аккуратные размеры для картинки на экране деталей
    final imageHeight = 350.0;
    final imageWidth = 500.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Центрируем картинку, чтобы она красиво смотрелась на больших экранах
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: imageHeight,
                  width: imageWidth,
                  child: Image.asset(
                    item.imagePath, 
                    fit: BoxFit.cover,
                    alignment: Alignment.center, // Центрируем сам кадр
                  ),
                ),
              ),
            ),
            20.ph,
            Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
            12.ph,
            const Divider(height: 1, color: Color.fromRGBO(0, 0, 0, 0.08)),
            16.ph,
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
