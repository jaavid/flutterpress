import 'package:flutter/material.dart';
import 'package:kermaneno/blocs/popular_articles_bloc.dart';
import 'package:kermaneno/cards/card1.dart';
import 'package:kermaneno/pages/popular_articles_page.dart';
import 'package:kermaneno/utils/loading_card.dart';
import 'package:kermaneno/utils/vertical_line.dart';
import '../utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class PopularArticles extends StatelessWidget {
  const PopularArticles({Key? key, required this.scaffoldKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    PopularArticlesBloc pb = context.watch<PopularArticlesBloc>();
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5, right: 15),
      child: Column(
        children: [
          Row(
            children: [
              verticalLine(context, 20.0),
              SizedBox(
                width: 5,
              ),
              Text('popular contents',
                  style: TextStyle(
                    letterSpacing: -0.7,
                    wordSpacing: 1,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  )).tr(),
              Spacer(),
              TextButton(
                child: Text(
                  'view all',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14),
                ).tr(),
                onPressed: () {
                  nextScreen(context, PopularArticlesPage());
                },
              )
            ],
          ),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 5, bottom: 15),
            itemCount: pb.articles.isEmpty ? 3 : pb.articles.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (pb.articles.isEmpty) {
                if (pb.hasData) {
                  return LoadingCard(
                    height: 200,
                  );
                } else {
                  return _NoContents();
                }
              } else {
                return Card1(
                  article: pb.articles[index],
                  heroTag: 'popular${pb.articles[index].id}',
                  scaffoldKey: scaffoldKey,
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class _NoContents extends StatelessWidget {
  const _NoContents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
      child: Text('No contents found!'),
    );
  }
}
