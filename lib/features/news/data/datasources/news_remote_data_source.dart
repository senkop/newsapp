import 'package:dio/dio.dart';
import 'package:task_app/core/api';
import 'package:task_app/core/error/exceptions.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlinesByCategory(String category, String countryCode);
  Future<List<ArticleModel>> getEverythingBySource(String sourceId);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiConsumer apiConsumer;
  final String baseUrl = 'https://saurav.tech/NewsAPI';

  NewsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<ArticleModel>> getTopHeadlinesByCategory(String category, String countryCode) async {
    try {
      final response = await apiConsumer.get(
        '$baseUrl/top-headlines/category/$category/$countryCode.json',
      );

      return (response['articles'] as List)
          .map((article) => ArticleModel.fromJson(article))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch top headlines: ${e.toString()}');
    }
  }

  @override
  Future<List<ArticleModel>> getEverythingBySource(String sourceId) async {
    try {
      final response = await apiConsumer.get(
        '$baseUrl/everything/$sourceId.json',
      );

      return (response['articles'] as List)
          .map((article) => ArticleModel.fromJson(article))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch news: ${e.toString()}');
    }
  }
}