import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kermaneno_app/common/constants.dart';
import 'package:kermaneno_app/models/Article.dart';
import 'package:kermaneno_app/pages/single_Article.dart';
import 'package:kermaneno_app/widgets/articleBox.dart';
import 'package:kermaneno_app/widgets/articleBoxFeatured.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

class Articles extends StatefulWidget {
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  List<dynamic> featuredArticles = [];
  List<dynamic> latestArticles = [];
  Future<List<dynamic>> _futureLastestArticles;
  Future<List<dynamic>> _futureFeaturedArticles;
  ScrollController _controller;
  int page = 1;
  bool _infiniteStop;

  @override
  void initState() {
    super.initState();
    _futureLastestArticles = fetchLatestArticles(1);
    _futureFeaturedArticles = fetchFeaturedArticles(1);
    _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
    _infiniteStop = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<List<dynamic>> fetchLatestArticles(int page) async {
    try {
      var response = await http.get(
      //  '$WORDPRESS_URL/wp-json/wp/v2/posts/?page=$page&per_page=10&_fields=id,date,title,content,custom,link'
          '$WORDPRESS_URL/wp-json/wp/v2/posts/?page=$page&per_page=10&_embed'
      );
      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            latestArticles.addAll(json.decode(response.body).map((m) => Article.fromJson(m)).toList());
            if (latestArticles.length % 10 != 0) {
              _infiniteStop = true;
            }
          });
          return latestArticles;
        }
        setState(() {_infiniteStop = true;});
      }
    } on SocketException {throw 'اتصال اینترنت برقرار نیست';}
    return latestArticles;
  }

  Future<List<dynamic>> fetchFeaturedArticles(int page) async {
    try {
      var response = await http.get(
          // "$WORDPRESS_URL/wp-json/wp/v2/posts/?categories[]=$FEATURED_ID&page=$page&per_page=10&_fields=id,date,title,content,custom,link"
          // Try to fetch featured media without plugin
          "$WORDPRESS_URL/wp-json/wp/v2/posts/?categories[]=$FEATURED_ID&page=$page&per_page=10&_embed"
      );
      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            featuredArticles.addAll(json.decode(response.body).map((m) => Article.fromJson(m)).toList());
          });
          return featuredArticles;
        } else {setState(() {_infiniteStop = true;});}
      }
    } on SocketException {throw 'اتصال اینترنت برقرار نیست';}
    return featuredArticles;
  }

  _scrollListener() {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        _futureLastestArticles = fetchLatestArticles(page);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Image(image: AssetImage('assets/icon.png'), height: 45,),
          elevation: 5,
          backgroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white70),
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                featuredPost(_futureFeaturedArticles),
                latestPosts(_futureLastestArticles)
              ],
            ),
          ),
        ));
  }

  Widget latestPosts(Future<List<dynamic>> latestArticles) {
    return FutureBuilder<List<dynamic>>(
      future: latestArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return Column(
            children: <Widget>[
              Column(
                  children: articleSnapshot.data.map((item) {
                final heroId = item.id.toString() + "-latest";
                return InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SingleArticle(item, heroId),),);},
                  child: articleBox(context, item, heroId),
                );
              }).toList()),
              !_infiniteStop
                  ? Container(
                      alignment: Alignment.center, height: 30,
                      child: Loading(indicator: BallBeatIndicator(), size: 60.0, color: Theme.of(context).accentColor)
              )
                  : Container()
            ],
          );
        } else if (articleSnapshot.hasError) {return Container();}
        return Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Loading(indicator: BallBeatIndicator(), size: 60.0, color: Theme.of(context).accentColor)
        );
      },
    );
  }

  Widget featuredPost(Future<List<dynamic>> featuredArticles) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<List<dynamic>>(
        future: featuredArticles,
        builder: (context, articleSnapshot) {
          if (articleSnapshot.hasData) {
            if (articleSnapshot.data.length == 0) return Container();
            return Row(
                children: articleSnapshot.data.map((item) {
              final heroId = item.id.toString() + "-featured";
              return InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SingleArticle(item, heroId)));},
                  child: articleBoxFeatured(context, item, heroId));
            }).toList());
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
                      _futureLastestArticles = fetchLatestArticles(1);
                      _futureFeaturedArticles = fetchFeaturedArticles(1);
                    },
                  )
                ],
              ),
            );
          }
          return Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 280,
              child: Loading(
                  indicator: BallBeatIndicator(),
                  size: 60.0,
                  color: Theme.of(context).accentColor));
        },
      ),
    );
  }
}
