import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kermaneno_app/models/Article.dart';
import 'package:html/dom.dart' as dom;

Widget articleBox(BuildContext context, Article article, String heroId) {
  return ConstrainedBox(
    constraints: new BoxConstraints(minHeight: 160.0, maxHeight: 175.0,),
    child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.fromLTRB(20, 16, 8, 0),
          child: Card(elevation: 6,
            child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 125, 0),
              child: Column(
                children: <Widget>[
                  Container(padding: EdgeInsets.fromLTRB(8, 0, 4, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Directionality(textDirection: TextDirection.rtl,
                             child: Html(
                              data: article.title.length > 100
                                  ? "<h1>" + article.title.substring(0, 100) + "...</h1>"
                                  : "<h1>" + article.title + "</h1>",
                              customTextAlign: (_)=>TextAlign.right,
                              customTextStyle:
                                  (dom.Node node, TextStyle baseStyle) {
                                if (node is dom.Element) {
                                  switch (node.localName) {
                                    case "h1":
                                      return baseStyle.merge(Theme.of(context).textTheme.title);
                                  }
                                }
                                return baseStyle;
                              })
                            ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(color: Color(0xFFE3E3E3), borderRadius: BorderRadius.circular(3)),
                                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text(article.category, style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w100)),),
                              Container(
                                padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.calendar_today, color: Colors.black45, size: 12.0),
                                    SizedBox(width: 4),
                                    Text(article.date, style: Theme.of(context).textTheme.caption),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 170, width: 145,
          child: Card(
            child: Hero(
              tag: heroId,
              child: ClipRRect(
//                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(article.thumb, fit: BoxFit.cover),
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
            elevation: 0,
            margin: EdgeInsets.all(10),
          ),
        ),
        //Container(),
      ],
    ),
  );
}
