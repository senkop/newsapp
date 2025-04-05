import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/core/api';
import 'package:task_app/core/error/exceptions.dart';
import 'package:task_app/features/news/data/datasources/news_local_data_source.dart';
import 'package:task_app/features/news/data/datasources/news_remote_data_source.dart';
import 'package:task_app/features/news/domain/repositories/news_repository.dart';
import 'package:task_app/features/news/domain/usecases/get_everything_by_source.dart';
import 'package:task_app/features/news/domain/usecases/get_top_headlines.dart';
import 'package:task_app/features/news/presentation/cubit/news_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //! Features - News
  // Cubit
  sl.registerFactory(
    () => NewsCubit(
      getTopHeadlinesByCategoryUseCase: sl(),
      getEverythingBySourceUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTopHeadlinesByCategory(sl()));
  sl.registerLazySingleton(() => GetEverythingBySource(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      localDataSource: sl(), 
      remoteDataSource: sl(), 
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(apiConsumer: sl()),
  );
  
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  
  sl.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(client: sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}