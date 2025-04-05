import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/news_cubit.dart';
import '../widgets/article_item.dart';
import 'source_news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'general';
  String _selectedCountry = 'us';
  
  final List<Map<String, String>> _categories = [
    {'code': 'general', 'name': 'General'},
    {'code': 'business', 'name': 'Business'},
    {'code': 'entertainment', 'name': 'Entertainment'},
    {'code': 'health', 'name': 'Health'},
    {'code': 'science', 'name': 'Science'},
    {'code': 'sports', 'name': 'Sports'},
    {'code': 'technology', 'name': 'Technology'},
  ];
  
  final List<Map<String, String>> _countries = [
    {'code': 'us', 'name': 'United States'},
    {'code': 'gb', 'name': 'United Kingdom'},
    {'code': 'in', 'name': 'India'},
    {'code': 'au', 'name': 'Australia'},
    {'code': 'ru', 'name': 'Russia'},
    {'code': 'fr', 'name': 'France'},
  ];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    BlocProvider.of<NewsCubit>(context).getTopHeadlinesByCategory(
      category: _selectedCategory,
      countryCode: _selectedCountry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String sourceId) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SourceNewsPage(sourceId: sourceId),
                ),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'bbc-news',
                child: Text('BBC News'),
              ),
              const PopupMenuItem<String>(
                value: 'cnn',
                child: Text('CNN'),
              ),
              const PopupMenuItem<String>(
                value: 'fox-news',
                child: Text('Fox News'),
              ),
              const PopupMenuItem<String>(
                value: 'google-news',
                child: Text('Google News'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter bar
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Row(
              children: [
                // Country dropdown
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCountry,
                    hint: const Text('Country'),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCountry = newValue;
                        });
                        _loadNews();
                      }
                    },
                    items: _countries.map<DropdownMenuItem<String>>((Map<String, String> country) {
                      return DropdownMenuItem<String>(
                        value: country['code'],
                        child: Text(country['name']!),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                // Category dropdown
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: const Text('Category'),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                        _loadNews();
                      }
                    },
                    items: _categories.map<DropdownMenuItem<String>>((Map<String, String> category) {
                      return DropdownMenuItem<String>(
                        value: category['code'],
                        child: Text(category['name']!),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // News list
          Expanded(
            child: RefreshIndicator(
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
                  
                  // NewsInitial state or any other state
                  return const Center(child: Text('Please wait...'));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}