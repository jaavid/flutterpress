import 'dart:convert';

import 'package:flutter/material.dart';
import '../config/wp_config.dart';
import '../models/article.dart';
import 'package:http/http.dart' as http;

class PopularArticlesBloc extends ChangeNotifier {


  List<Article> _articles = [];
  List<Article> get articles => _articles;

  int _contentAmount = 4;
  final String _timeRange = 'last30days';


  bool _hasData = true;
  bool get hasData => _hasData;

  Future fetchData() async {
    _hasData = true;
    _articles.clear();
    notifyListeners();
    
    var response = WpConfig.blockedCategoryIdsforPopularPosts.isEmpty
      ? await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wordpress-popular-posts/v1/popular-posts?range=$_timeRange&" + "limit=$_contentAmount"))
      : await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wordpress-popular-posts/v1/popular-posts?range=$_timeRange&" + "limit=$_contentAmount&cat=" + WpConfig.blockedCategoryIdsforPopularPosts));
        
    List? decodedData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _articles = decodedData!.map((m) => Article.fromJson(m)).toList();
      if(_articles.isEmpty){
        _hasData = false;
      } 
    }
    notifyListeners();
  }
}
