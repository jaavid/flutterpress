import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kermaneno/config/wp_config.dart';
import 'package:kermaneno/models/article.dart';
import 'package:http/http.dart' as http;

class CategoryTab2Bloc extends ChangeNotifier {
  List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool? _isLoading;
  bool? get isLoading => _isLoading;

  bool _hasData = true;
  bool get hasData => _hasData;

  bool _dataLoaded = false;
  bool get dataLoaded => _dataLoaded;

  int _page = 1;
  int get page => _page;

  int _postAmountPerLoad = 10;

  Future fetchData(int categoryId, mounted) async {
    var response = WpConfig.blockedCategoryIds.isEmpty
        ? await http.get(Uri.parse(
            "${WpConfig.websiteUrl}/wp-json/wp/v2/posts?categories[]=" +
                categoryId.toString() +
                "&page=$_page&per_page=$_postAmountPerLoad"))
        : await http.get(Uri.parse(
            "${WpConfig.websiteUrl}/wp-json/wp/v2/posts?categories[]=" +
                categoryId.toString() +
                "&page=$_page&per_page=$_postAmountPerLoad&categories_exclude=" +
                WpConfig.blockedCategoryIds));

    if (mounted) {
      if (response.statusCode == 200) {
        List? decodedData = jsonDecode(response.body);
        _articles.addAll(decodedData!.map((m) => Article.fromJson(m)).toList());
        _isLoading = false;
        if (_articles.length == 0) {
          _hasData = false;
          _dataLoaded = true;
          notifyListeners();
        } else {
          _hasData = true;
          _dataLoaded = true;
          notifyListeners();
        }
      }
    }
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  pageIncreament() {
    _page += 1;
    notifyListeners();
  }

  onReload(int categoryId, mounted) async {
    _isLoading = null;
    _hasData = true;
    _dataLoaded = false;
    _articles.clear();
    _page = 1;
    notifyListeners();
    await fetchData(categoryId, mounted);
  }
}
