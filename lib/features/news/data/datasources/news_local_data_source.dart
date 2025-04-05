import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/core/error/exceptions.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<List<ArticleModel>> getLastTopHeadlines();
  Future<void> cacheTopHeadlines(List<ArticleModel> articles);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final SharedPreferences sharedPreferences;
  final String cachedTopHeadlinesKey = 'CACHED_TOP_HEADLINES';

  NewsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ArticleModel>> getLastTopHeadlines() async {
    final jsonString = sharedPreferences.getString(cachedTopHeadlinesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => ArticleModel.fromJson(e)).toList();
    } else {
      throw CacheException('No cached data found');
    }
  }

  @override
  Future<void> cacheTopHeadlines(List<ArticleModel> articles) async {
    final List<Map<String, dynamic>> jsonList = articles.map((article) => article.toJson()).toList();
    await sharedPreferences.setString(cachedTopHeadlinesKey, json.encode(jsonList));
  }
}