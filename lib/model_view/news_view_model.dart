import 'package:news/model/category_model.dart';
import 'package:news/model/news_channelhealine_model.dart';
import 'package:news/repository/news_repository.dart';

class NewsViewModel{
  final _res = NewsRepository();

  Future <NewsChannelHeadlineModel> FetchNewsHeadlineApi(String channelName) async{
    final response = await _res.FetchNewsHeadlineApi(channelName);
    return response;
  }

  Future<CategoryNews> FetchCategoriesNews(String categoryNews) async{
    final response = await _res.FetchCategoriesNews(categoryNews);
    return response;
  }
}