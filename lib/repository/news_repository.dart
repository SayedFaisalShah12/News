import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/model/category_model.dart';
import 'package:news/model/news_channelhealine_model.dart';

class NewsRepository{

  Future<NewsChannelHeadlineModel> FetchNewsHeadlineApi(String channelNews) async {
    String url = 'https://newsapi.org/v2/top-headlines?sources=${channelNews}&apikey=36c6444a97594a54a47711b34e5d0647';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlineModel.fromJson(body);
    }
    throw Exception("error");
  }

  Future<CategoryNews> FetchCategoriesNews(String categoryNews) async {
    String url = 'https://newsapi.org/v2/everything?q=${categoryNews}&apiKey=36c6444a97594a54a47711b34e5d0647';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final categoryBody = jsonDecode(response.body);
      return CategoryNews.fromJson(categoryBody);
    }
    throw Exception("error");
  }
}