import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/news_cubit.dart';
import '../widgets/article_item.dart';

class SourceNewsPage extends StatefulWidget {
  final String sourceId;

  const SourceNewsPage({Key? key, required this.sourceId}) : super(key: key);

  @override
  _SourceNewsPageState createState() => _SourceNewsPageState();
}

class _SourceNewsPageState extends State<SourceNewsPage> {
  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    BlocProvider.of<NewsCubit>(context).getEverythingBySource(
      sourceId: widget.sourceId,
    );
  }

  String _getSourceName() {
    switch (widget.sourceId) {
      case 'bbc-news':
        return 'BBC News';
      case 'cnn':
        return 'CNN';
      case 'fox-news':
        return 'Fox News';
      case 'google-news':
        return 'Google News';
      default:
        return widget.sourceId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getSourceName()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadNews();
        },
        child: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: _loadNews,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (state is NewsLoaded) {
              return state.articles.isEmpty
                  ? const Center(child: Text('No articles found'))
                  : ListView.builder(
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        return ArticleItem(article: state.articles[index]);
                      },
                    );
            }
            
            return const Center(child: Text('Please wait...'));
          },
        ),
      ),
    );
  }
}