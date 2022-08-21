import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kermaneno/config/wp_config.dart';
import 'package:kermaneno/models/article.dart';
import 'package:http/http.dart' as http;
import 'package:kermaneno/pages/article_details.dart';
import 'package:kermaneno/pages/video_article_details.dart';
import 'package:kermaneno/widgets/loading_indicator_widget.dart';

class PostNotificationDetails extends StatefulWidget {
  final int postID;
  PostNotificationDetails({Key? key, required this.postID}) : super(key: key);

  @override
  _PostNotificationDetailsState createState() =>
      _PostNotificationDetailsState();
}

class _PostNotificationDetailsState extends State<PostNotificationDetails> {
  Future<Article?> fetchPostsByCategoryId() async {
    Article? article;
    var response = await http.get(Uri.parse(
        "${WpConfig.websiteUrl}/wp-json/wp/v2/posts/${widget.postID}"));
    var decodedData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      article = Article.fromJson(decodedData);
    }
    return article;
  }

  late Future _fetchData;

  @override
  void initState() {
    _fetchData = fetchPostsByCategoryId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchData,
      builder: (context, AsyncSnapshot snap) {
        if (snap.connectionState == ConnectionState.active ||
            snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: LoadingIndicatorWidget()),
          );
        } else if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Something is wrong. Please try again!'),
            ),
          );
        } else {
          Article article = snap.data;
          if (article.tags == null ||
              !article.tags!.contains(WpConfig.videoTagId)) {
            return ArticleDetails(articleData: article);
          } else {
            return VideoArticleDeatils(article: article);
          }
        }
      },
    );
  }
}
