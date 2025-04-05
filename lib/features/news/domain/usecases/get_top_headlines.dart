import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlinesByCategory {
  final NewsRepository repository;

  GetTopHeadlinesByCategory(this.repository);

  Future<Either<Failure, List<Article>>> call(TopHeadlinesParams params) async {
    return await repository.getTopHeadlinesByCategory(params.category, params.countryCode);
  }
}

class TopHeadlinesParams extends Equatable {
  final String category;
  final String countryCode;

  const TopHeadlinesParams({
    required this.category,
    required this.countryCode,
  });

  @override
  List<Object> get props => [category, countryCode];
}