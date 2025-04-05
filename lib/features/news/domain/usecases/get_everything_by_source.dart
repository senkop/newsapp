import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetEverythingBySource {
  final NewsRepository repository;

  GetEverythingBySource(this.repository);

  Future<Either<Failure, List<Article>>> call(SourceParams params) async {
    return await repository.getEverythingBySource(params.sourceId);
  }
}

class SourceParams extends Equatable {
  final String sourceId;

  const SourceParams({required this.sourceId});

  @override
  List<Object> get props => [sourceId];
}