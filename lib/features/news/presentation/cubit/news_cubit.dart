import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_app/features/news/domain/usecases/get_top_headlines.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_everything_by_source.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetTopHeadlinesByCategory getTopHeadlinesByCategoryUseCase;
  final GetEverythingBySource getEverythingBySourceUseCase;

  NewsCubit({
    required this.getTopHeadlinesByCategoryUseCase,
    required this.getEverythingBySourceUseCase,
  }) : super(NewsInitial());

  Future<void> getTopHeadlinesByCategory({
    String category = 'general',
    String countryCode = 'us',
  }) async {
    emit(NewsLoading());
    
    final result = await getTopHeadlinesByCategoryUseCase(
      TopHeadlinesParams(category: category, countryCode: countryCode),
    );
    
    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (articles) => emit(NewsLoaded(articles)),
    );
  }

  Future<void> getEverythingBySource({required String sourceId}) async {
    emit(NewsLoading());
    
    final result = await getEverythingBySourceUseCase(
      SourceParams(sourceId: sourceId),
    );
    
    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (articles) => emit(NewsLoaded(articles)),
    );
  }
}