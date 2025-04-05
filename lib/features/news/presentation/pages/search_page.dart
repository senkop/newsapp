import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/news_cubit.dart';
import '../widgets/article_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, String>> _sources = [
    {'id': 'bbc-news', 'name': 'BBC News'},
    {'id': 'cnn', 'name': 'CNN'},
    {'id': 'fox-news', 'name': 'Fox News'},
    {'id': 'google-news', 'name': 'Google News'},
  ];
  
  String? _selectedSourceId;
  bool _isSourceSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find News by Source'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Source selection
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Select a news source'),
              value: _selectedSourceId,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSourceId = newValue;
                    _isSourceSelected = true;
                  });
                  BlocProvider.of<NewsCubit>(context).getEverythingBySource(
                    sourceId: newValue,
                  );
                }
              },
              items: _sources.map<DropdownMenuItem<String>>((Map<String, String> source) {
                return DropdownMenuItem<String>(
                  value: source['id'],
                  child: Text(source['name']!),
                );
              }).toList(),
            ),
          ),
          
          // Results
          Expanded(
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
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedSourceId != null) {
                              BlocProvider.of<NewsCubit>(context).getEverythingBySource(
                                sourceId: _selectedSourceId!,
                              );
                            }
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (state is NewsLoaded) {
                  return state.articles.isEmpty
                      ? const Center(child: Text('No results found'))
                      : ListView.builder(
                          itemCount: state.articles.length,
                          itemBuilder: (context, index) {
                            return ArticleItem(article: state.articles[index]);
                          },
                        );
                }
                
                // NewsInitial state or when nothing has been selected yet
                return Center(
                  child: !_isSourceSelected
                      ? const Text('Select a source to find news')
                      : const CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}