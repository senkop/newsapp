import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;
  final String content;
  final String sourceName;

  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.content,
    required this.sourceName,
  });

  @override
  List<Object> get props => [
    id, title, description, url, imageUrl, publishedAt, content, sourceName
  ];
}