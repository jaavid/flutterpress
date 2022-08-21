import 'dart:convert';

import 'package:flutter/material.dart';
import '../config/wp_config.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;

class CategoryBloc extends ChangeNotifier {


  List<Category> _categoryData = [];
  List<Category> get categoryData => _categoryData;

  Future fetchData() async {

    _categoryData.clear();
    notifyListeners();
    var response = WpConfig.blockedCategoryIds.isEmpty
      ? await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/categories?per_page=100&order=desc&orderby=count"))
      : await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/categories?per_page=100&order=desc&orderby=count&exclude=" + WpConfig.blockedCategoryIds));
    List? decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      _categoryData = decodedData!.map((m) => Category.fromJson(m)).toList();
    }
    notifyListeners();
  }

}
