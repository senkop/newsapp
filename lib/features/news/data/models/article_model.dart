import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required String id,
    required String title,
    required String description,
    required String url,
    required String imageUrl,
    required String publishedAt,
    required String content,
    required String sourceName,
  }) : super(
          id: id, 
          title: title, 
          description: description, 
          url: url, 
          imageUrl: imageUrl,
          publishedAt: publishedAt,
          content: content,
          sourceName: sourceName,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
      sourceName: json['source']['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': id,
      'title': title,
      'description': description,
      'urlToImage': imageUrl,
      'publishedAt': publishedAt,
      'content': content,
      'source': {'name': sourceName},
    };
  }
}