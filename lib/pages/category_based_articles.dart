import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/config/wp_config.dart';
import 'package:kermaneno/cards/sliver_card1.dart';
import 'package:kermaneno/utils/cached_image_with_dark.dart';
import 'package:kermaneno/utils/empty_image.dart';
import 'package:kermaneno/utils/loading_card.dart';
import 'package:kermaneno/widgets/loading_indicator_widget.dart';
import '../models/article.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class CategoryBasedArticles extends StatefulWidget {
  final String? categoryName;
  final int? categoryId;
  final String? categoryThumbnail;
  final String? heroTag;
  const CategoryBasedArticles(
      {Key? key,
      required this.categoryName,
      required this.categoryId,
      this.categoryThumbnail,
      this.heroTag})
      : super(key: key);

  @override
  _CategoryBasedArticlesState createState() => _CategoryBasedArticlesState();
}

class _CategoryBasedArticlesState extends State<CategoryBasedArticles> {
  List<Article> _articles = [];
  ScrollController? _controller;
  int page = 1;
  bool? _loading;
  bool? _hasData;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _postAmount = 10;

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);
    _fetchArticles(1);
    _hasData = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future _fetchArticles(int page) async {
    try {
      var response = await http.get(Uri.parse(
          "${WpConfig.websiteUrl}/wp-json/wp/v2/posts?categories[]=" +
              widget.categoryId.toString() +
              "&page=$page&per_page=$_postAmount"));

      if (this.mounted) {
        if (response.statusCode == 200) {
          List? decodedData = jsonDecode(response.body);
          setState(() {
            _articles
                .addAll(decodedData!.map((m) => Article.fromJson(m)).toList());
            _loading = false;
            if (_articles.length == 0) {
              _hasData = false;
            }
          });
        }
      }
    } on SocketException {
      throw 'No Internet connection';
    }
  }

  _scrollListener() async {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd && _articles.isNotEmpty) {
      setState(() {
        page += 1;
        _loading = true;
      });
      await _fetchArticles(page).then((value) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  Future _onRefresh() async {
    setState(() {
      _loading = null;
      _hasData = true;
      _articles.clear();
      page = 1;
    });
    await _fetchArticles(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: _controller,
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
              elevation: 0.5,
              flexibleSpace: _flexibleSpaceBar(context),
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

                          return Opacity(
                              opacity: _loading == true ? 1.0 : 0.0,
                              child: LoadingIndicatorWidget());
                        },
                        childCount:
                            _articles.isEmpty ? 6 : _articles.length + 1,
                      ),
                    ),
                  ),
          ],
        ),
        onRefresh: () async => _onRefresh(),
      ),
    );
  }

  FlexibleSpaceBar _flexibleSpaceBar(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: false,
      background: Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        child: widget.heroTag == null || widget.categoryThumbnail == null
            ? Container()
            : Hero(
                tag: widget.heroTag!,
                child: CustomCacheImageWithDarkFilterBottom(
                    imageUrl: widget.categoryThumbnail, radius: 0.0)),
      ),
      title: Text(widget.categoryName!,
          style: TextStyle(color: Colors.white, fontFamily: 'Vazir')),
      titlePadding: EdgeInsets.only(left: 20, bottom: 15, right: 20),
    );
  }
}
