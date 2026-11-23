import 'package:dio/dio.dart';

import '../../../data/dio/endpoints.dart';
import 'content_repository_interface.dart';
import 'model/content.dart';

class ContentRepository implements ContentRepositoryInterface {
  ContentRepository({required this.dio});

  final Dio dio;

  @override
  Future<List<Content>> getContent() async {
    try {
      final Response response = await dio.get(Endpoints.content);
      final content = (response.data['data'] as List)
          .map((e) => Content.fromJson(e))
          .toList();
      return content;
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }

  @override
  Future<Content> getContentById(int id) async {
    try {
      final Response response = await dio.get(Endpoints.contentById(id));
      return Content.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.message.toString();
    }
  }
}
