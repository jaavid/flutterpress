import 'dart:convert';

import 'package:flutter/material.dart';
import '../config/wp_config.dart';
import '../models/article.dart';
import 'package:http/http.dart' as http;

class FeaturedBloc extends ChangeNotifier {

  
  List<Article> _articles = [];
  List<Article> get articles => _articles;
  int _contentAmount = 5;

  bool _hasData = true;
  bool get hasData => _hasData;

  int _dotIndex = 0;
  int get dotIndex => _dotIndex;

  Future fetchData() async {
    _hasData = true;
    _articles.clear();
    notifyListeners();
    
    var response = WpConfig.blockedCategoryIds.isEmpty
      ? await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/posts?tags=${WpConfig.featuredTagID}&per_page=$_contentAmount"))
      : await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/posts?tags=${WpConfig.featuredTagID}&per_page=$_contentAmount&categories_exclude=" + WpConfig.blockedCategoryIds));
        
    List? decodedData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _articles = decodedData!.map((m) => Article.fromJson(m)).toList();
      if(_articles.isEmpty){
        _hasData = false;
      } 
    }else{
      _hasData = false;
    }
    notifyListeners();
  }

  void saveDotIndex (int newIndex){
    _dotIndex = newIndex;
    notifyListeners();
  }
}
