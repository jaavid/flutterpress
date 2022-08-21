import 'package:flutter/material.dart';
import 'package:kermaneno/cards/card6.dart';
import 'package:kermaneno/cards/card4.dart';
import 'package:kermaneno/models/article.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:kermaneno/utils/vertical_line.dart';
import '../blocs/latest_articles_bloc.dart';
import 'loading_indicator_widget.dart';

class LattestArticles extends StatelessWidget {
  const LattestArticles({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final articles = context.watch<LatestArticlesBloc>().articles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
          ),
          child: Row(
            children: [
              verticalLine(context, 20.0),
              SizedBox(
                width: 5,
              ),
              Text('recent contents',
                      style: TextStyle(
                          letterSpacing: -0.7,
                          wordSpacing: 1,
                          fontWeight: FontWeight.w700,
                          fontSize: 18))
                  .tr(),
            ],
          ),
        ),
        articles.isEmpty
            ? Container()
            : ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(15),
                shrinkWrap: true,
                itemCount: articles.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 15,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Article article = articles[index];
                  if (index % 2 == 0)
                    return Card4(
                      article: article,
                      heroTag: 'recent${article.id}',
                      scaffoldKey: scaffoldKey,
                    );
                  else if (index % 3 == 0)
                    return Card4(
                      article: article,
                      heroTag: 'recenta${article.id}',
                      scaffoldKey: scaffoldKey,
                    );
                  return Card6(
                      article: article,
                      heroTag: 'recentaa${article.id}',
                      scaffoldKey: scaffoldKey);
                },
              ),
        Opacity(
          opacity:
              context.watch<LatestArticlesBloc>().loading == true ? 1.0 : 0.0,
          child: LoadingIndicatorWidget(),
        ),
      ],
    );
  }
}
