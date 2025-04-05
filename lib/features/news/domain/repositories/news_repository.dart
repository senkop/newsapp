import 'package:dartz/dartz.dart';
import 'package:task_app/core/error/exceptions.dart';
import 'package:task_app/features/news/data/datasources/news_local_data_source.dart';
import 'package:task_app/features/news/data/datasources/news_remote_data_source.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlinesByCategory(String category, String countryCode);
  Future<Either<Failure, List<Article>>> getEverythingBySource(String sourceId);
}

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlinesByCategory(String category, String countryCode) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.getTopHeadlinesByCategory(category, countryCode);
        localDataSource.cacheTopHeadlines(remoteArticles);
        return Right(remoteArticles);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localArticles = await localDataSource.getLastTopHeadlines();
        return Right(localArticles);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getEverythingBySource(String sourceId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.getEverythingBySource(sourceId);
        return Right(remoteArticles);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(const NetworkFailure('No Internet Connection'));
    }
  }
}