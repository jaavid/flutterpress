import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kermaneno/models/article.dart';
import 'package:kermaneno/services/app_service.dart';
import 'package:kermaneno/services/bookmark_service.dart';
import 'package:kermaneno/utils/cached_image.dart';
import 'package:kermaneno/utils/next_screen.dart';
import 'package:kermaneno/widgets/video_icon.dart';

class BookmarkCard extends StatelessWidget {
  final Article article;
  const BookmarkCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String heroTag = 'bookmark${article.id}';
    return InkWell(
        child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      child: Hero(
                          tag: heroTag,
                          child: CustomCacheImage(
                              imageUrl: article.image, radius: 5)),
                    ),
                    VideoIcon(tags: article.tags, iconSize: 40)
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 110,
                    padding: EdgeInsets.only(top: 0, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppService.getNormalText(article.title!),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.time,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(article.timeAgo!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                Spacer(),
                                IconButton(
                                    alignment: Alignment.centerRight,
                                    icon: Icon(Icons.close, size: 16),
                                    onPressed: () => BookmarkService()
                                        .removeFromBookmarkList(article))
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
        onTap: () => navigateToDetailsScreen(context, article, heroTag));
  }
}
