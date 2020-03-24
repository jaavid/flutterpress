import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kermaneno_app/common/constants.dart';
import 'package:kermaneno_app/models/Article.dart';
import 'package:kermaneno_app/pages/single_article.dart';
import 'package:kermaneno_app/widgets/articleBox.dart';
import 'package:kermaneno_app/widgets/searchBoxes.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchText = "";
  List<dynamic> searchedArticles = [];
  Future<List<dynamic>> _futureSearchedArticles;
  ScrollController _controller;
  final TextEditingController _textFieldController =
      new TextEditingController();

  int page = 1;
  bool _infiniteStop;

  @override
  void initState() {
    super.initState();
    _futureSearchedArticles =
        fetchSearchedArticles(_searchText, _searchText == "", page, false);
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
    _infiniteStop = false;
  }

  Future<List<dynamic>> fetchSearchedArticles(
      String searchText, bool empty, int page, bool scrollUpdate) async {
    try {
      if (empty) {
        searchText = "12g2g12vhgv2hg1v2ghv1hg2vhg1v2gh1v2"; // No posts.
      }

      var response = await http.get(
          "$WORDPRESS_URL/wp-json/wp/v2/posts?search=$searchText&page=$page&per_page=10&_embed");

      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            if (scrollUpdate) {
              searchedArticles.addAll(json
                  .decode(response.body)
                  .map((m) => Article.fromJson(m))
                  .toList());
            } else {
              searchedArticles = json
                  .decode(response.body)
                  .map((m) => Article.fromJson(m))
                  .toList();
            }

            if (searchedArticles.length % 10 != 0) {
              _infiniteStop = true;
            }
          });

          return searchedArticles;
        }
        setState(() {
          _infiniteStop = true;
        });
      }
    } on SocketException {
      throw 'اتصال اینترنت برقرار نیست';
    }
    return searchedArticles;
  }

  _scrollListener() {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        _futureSearchedArticles =
            fetchSearchedArticles(_searchText, _searchText == "", page, true);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textFieldController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('جستجو',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Vazir')),
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: TextField(
                        controller: _textFieldController,
                        decoration: InputDecoration(
                          labelText: 'جستجوی خبرها',
                          suffixIcon: _searchText == ""
                              ? Icon(Icons.search)
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    _textFieldController.clear();
                                    setState(() {
                                      _searchText = "";
                                      _futureSearchedArticles =
                                          fetchSearchedArticles(_searchText,
                                              _searchText == "", page, false);
                                    });
                                  },
                                ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (text) {
                          setState(() {
                            _searchText = text;
                            page = 1;
                            _futureSearchedArticles = fetchSearchedArticles(
                                _searchText, _searchText == "", page, false);
                          });
                        }),
                  ),
                ),
              ),
              searchPosts(_futureSearchedArticles)
            ],
          ),
        ),
      ),
    );
  }

  Widget searchPosts(Future<List<dynamic>> articles) {
    return FutureBuilder<List<dynamic>>(
      future: articles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) {
            return Column(children: <Widget>[searchBoxes(context),],);
          }
          return Column(
            children: <Widget>[
              Column(
                  children: articleSnapshot.data.map((item) {
                final heroId = item.id.toString() + "-searched";
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SingleArticle(item, heroId),),
                    );
                  },
                  child: articleBox(context, item, heroId),
                );
              }).toList()),
              !_infiniteStop
                  ? Container(
                      alignment: Alignment.center,
                      height: 30,
                      child: Loading(
                          indicator: BallBeatIndicator(),
                          size: 60.0,
                          color: Theme.of(context).accentColor))
                  : Container()
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Image.asset("assets/no-internet.png", width: 250,),
                Text("اتصال اینترنت برقرار نیست."),
                FlatButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text("بارگزاری مجدد"),
                  onPressed: () {
                    _futureSearchedArticles = fetchSearchedArticles(
                        _searchText, _searchText == "", page, false);
                  },
                )
              ],
            ),
          );
        }
        return Container(
            alignment: Alignment.center,
            width: 300,
            height: 150,
            child: Loading(
                indicator: BallBeatIndicator(),
                size: 60.0,
                color: Theme.of(context).accentColor));
      },
    );
  }
}
