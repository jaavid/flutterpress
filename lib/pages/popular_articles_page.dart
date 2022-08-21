import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/config/wp_config.dart';
import 'package:kermaneno/cards/sliver_card1.dart';
import 'package:kermaneno/utils/empty_image.dart';
import 'package:kermaneno/utils/loading_card.dart';
import '../models/article.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

class PopularArticlesPage extends StatefulWidget {
  const PopularArticlesPage({Key? key}) : super(key: key);

  @override
  _PopularArticlesPageState createState() => _PopularArticlesPageState();
}

class _PopularArticlesPageState extends State<PopularArticlesPage> {
  List<Article> _articles = [];
  bool? _hasData;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final String _timeRange = 'last30days';
  final int _postLimit = 50;

  @override
  void initState() {
    _fetchArticles();
    _hasData = true;
    super.initState();
  }

  Future _fetchArticles() async {
    var response = WpConfig.blockedCategoryIdsforPopularPosts.isEmpty
        ? await http.get(Uri.parse(
            "${WpConfig.websiteUrl}/wp-json/wordpress-popular-posts/v1/popular-posts?range=$_timeRange&limit=$_postLimit"))
        : await http.get(Uri.parse(
            "${WpConfig.websiteUrl}/wp-json/wordpress-popular-posts/v1/popular-posts?range=$_timeRange&limit=$_postLimit&cat=" +
                WpConfig.blockedCategoryIdsforPopularPosts));
    if (this.mounted) {
      if (response.statusCode == 200) {
        List? decodedData = jsonDecode(response.body);
        setState(() {
          _articles
              .addAll(decodedData!.map((m) => Article.fromJson(m)).toList());
          if (_articles.length == 0) {
            _hasData = false;
          }
        });
      }
    }
  }

  Future _onRefresh() async {
    setState(() {
      _hasData = true;
      _articles.clear();
    });
    await _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              backgroundColor: Theme.of(context).primaryColor,
              expandedHeight: MediaQuery.of(context).size.height * 0.15,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                background: Container(
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                ),
                title: Text('popular contents',
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Vazir'))
                    .tr(),
                titlePadding: EdgeInsets.only(left: 20, bottom: 15, right: 20),
              ),
            ),
            _hasData == false
                ? SliverFillRemaining(
                    child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20,
                      ),
                      EmptyPageWithImage(
                          image: Config.noContentImage,
                          title: 'no contents found'.tr()),
                    ],
                  ))
                : SliverPadding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (_articles.isEmpty && _hasData == true) {
                            return Container(
                                padding: EdgeInsets.only(bottom: 15),
                                child: LoadingCard(height: 250));
                          } else if (index < _articles.length) {
                            return SliverCard1(
                                article: _articles[index],
                                heroTag: 'categoryBased$index',
                                scaffoldKey: scaffoldKey);
                          }
                          return null;
                        },
                        childCount:
                            _articles.isEmpty ? 6 : _articles.length + 1,
                      ),
                    ),
                  )
          ],
        ),
        onRefresh: () async => _onRefresh(),
      ),
    );
  }
}
