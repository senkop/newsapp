// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/article.dart';
// import '../repositories/news_repository.dart';

// class SearchNews {
//   final NewsRepository repository;

//   SearchNews(this.repository);

//   Future<Either<Failure, List<Article>>> call(SearchParams params) async {
//     return await repository.searchNews(params.query);
//   }
// }

// class SearchParams extends Equatable {
//   final String query;

//   const SearchParams({required this.query});

//   @override
//   List<Object> get props => [query];
// }