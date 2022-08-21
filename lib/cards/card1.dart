import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kermaneno/models/article.dart';
import 'package:kermaneno/models/constants.dart';
import 'package:kermaneno/services/app_service.dart';
import 'package:kermaneno/utils/cached_image.dart';
import 'package:kermaneno/utils/next_screen.dart';
import 'package:kermaneno/widgets/bookmark_icon.dart';
import 'package:kermaneno/widgets/video_icon.dart';

//small card with right sight image
class Card1 extends StatelessWidget {
  final Article article;
  final String heroTag;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const Card1(
      {Key? key,
      required this.article,
      required this.heroTag,
      required this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmarkedList = Hive.box(Constants.bookmarkTag);

    return InkWell(
        child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ]),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppService.getNormalText(article.title!),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blueGrey[600]),
                            child: Text(
                              article.category!,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Hero(
                      tag: heroTag,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CustomCacheImage(
                                imageUrl: article.image, radius: 5.0),
                          ),
                          VideoIcon(
                            tags: article.tags,
                            iconSize: 40,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.time,
                      size: 18,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      article.timeAgo!,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    BookmarkIcon(
                      bookmarkedList: bookmarkedList,
                      article: article,
                      iconSize: 18,
                      scaffoldKey: scaffoldKey,
                    )
                  ],
                ),
              ],
            )),
        onTap: () => navigateToDetailsScreen(context, article, heroTag));
  }
}
