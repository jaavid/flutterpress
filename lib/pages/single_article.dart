import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kermaneno_app/blocs/favArticleBloc.dart';
import 'package:kermaneno_app/common/constants.dart';
import 'package:kermaneno_app/models/Article.dart';
import 'package:kermaneno_app/pages/comments.dart';
import 'package:kermaneno_app/widgets/articleBox.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'package:share/share.dart';

class SingleArticle extends StatefulWidget {
  final dynamic article;
  final String heroId;
  SingleArticle(this.article, this.heroId, {Key key}) : super(key: key);
  @override
  _SingleArticleState createState() => _SingleArticleState();
}

class _SingleArticleState extends State<SingleArticle> {
  List<dynamic> relatedArticles = [];
  Future<List<dynamic>> _futureRelatedArticles;
  final FavArticleBloc favArticleBloc = FavArticleBloc();
  Future<dynamic> favArticle;
  @override
  void initState() {
    super.initState();
    _futureRelatedArticles = fetchRelatedArticles();
    favArticle = favArticleBloc.getFavArticle(widget.article.id);
  }

  Future<List<dynamic>> fetchRelatedArticles() async {
    try {
      int postId = widget.article.id;
      int catId = widget.article.catId;
      var response = await http.get("$WORDPRESS_URL/wp-json/wp/v2/posts?exclude=$postId&categories[]=$catId&per_page=3&_embed");
      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            relatedArticles = json.decode(response.body).map((m) => Article.fromJson(m)).toList();
          });
          return relatedArticles;
        }
      }
    } on SocketException {throw 'اتصال اینترنت برقرار نیست';}
    return relatedArticles;
  }

  @override
  void dispose() {
    super.dispose();
    relatedArticles = [];
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final heroId = widget.heroId;

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.white70),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      child: Hero(tag: heroId,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.overlay),
                          child: Image.network(article.bigimage, fit: BoxFit.fitWidth),
                        )
                     )
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back), color: Colors.white,
                        onPressed: () {Navigator.of(context).pop();},
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Html(
                          data: "<h1>" + article.title + "</h1>",
                          customTextAlign: (_)=>TextAlign.right,
                          padding: EdgeInsets.fromLTRB(5, 5, 15, 0),
                          customTextStyle:
                              (dom.Node node, TextStyle baseStyle) {
                            if (node is dom.Element) {
                              switch (node.localName) {
                                case "h1":
                                  return Theme.of(context).textTheme.title.merge(TextStyle(fontSize: 20));
                              }
                            }
                            return baseStyle;
                          }),
                      Container(
                        decoration: BoxDecoration(color: Color(0xFFE3E3E3), borderRadius: BorderRadius.circular(3)),
                        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        margin: EdgeInsets.all(16),
                        child: Text(article.category, style: TextStyle(color: Colors.black, fontSize: 11, fontFamily: 'Vazir')),
                      ),
                      SizedBox(height: 45, child: ListTile(title: Text(article.date, style: TextStyle(fontSize: 11)))),
                      Directionality(textDirection: TextDirection.rtl,
                        child:Html(
                          data: "<div>" + article.content + "</div>",
                          customTextAlign: (_)=>TextAlign.right,
                          padding: EdgeInsets.fromLTRB(16, 36, 16, 50),
                          customTextStyle:
                              (dom.Node node, TextStyle baseStyle) {
                            if (node is dom.Element) {
                              switch (node.localName) {
                                case "div":
                                  return baseStyle.merge(Theme.of(context).textTheme.body1);
                              }
                            }
                            return baseStyle;
                          })
                       ),
                    ],
                  ),
                ),
                relatedPosts(_futureRelatedArticles)
              ],
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(color: Colors.white10),
          height: 50,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FutureBuilder<dynamic>(
                  future: favArticle,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        decoration: BoxDecoration(),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.favorite, color: Colors.red, size: 24.0,),
                          onPressed: () {
                            // Favourite post
                            favArticleBloc.deleteFavArticleById(article.id);
                            setState(() {favArticle = favArticleBloc.getFavArticle(article.id);});
                          },
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.favorite_border, color: Colors.red, size: 24.0,),
                        onPressed: () {
                          favArticleBloc.addFavArticle(article);
                          setState(() {favArticle = favArticleBloc.getFavArticle(article.id);});
                        },
                      ),
                    );
                  }),
              Container(
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.comment, color: Colors.blue, size: 24.0,),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Comments(article.id), fullscreenDialog: true,));
                  },
                ),
              ),
              Container(
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.share, color: Colors.green, size: 24.0,),
                  onPressed: () {Share.share('همرسانی خبر: ' + article.link);},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget relatedPosts(Future<List<dynamic>> latestArticles) {
    return FutureBuilder<List<dynamic>>(
      future: latestArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return Directionality(textDirection: TextDirection.rtl,
                child:Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.all(16),
                      child: Text("اخبار مرتبط", textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: "Vazir"),),
                    ),
                    Column(
                      children: articleSnapshot.data.map((item) {
                        final heroId = item.id.toString() + "-related";
                        return InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingleArticle(item, heroId),),);
                          },
                          child: articleBox(context, item, heroId),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24)
                  ],
                )
            );
        } else if (articleSnapshot.hasError) {
          return Container(height: 500, alignment: Alignment.center, child: Text("${articleSnapshot.error}"));
        }
        return Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Loading(indicator: BallBeatIndicator(), size: 60.0, color: Theme.of(context).accentColor)
        );
      },
    );
  }
}
