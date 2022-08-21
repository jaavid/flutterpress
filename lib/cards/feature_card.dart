import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kermaneno/models/article.dart';
import 'package:kermaneno/services/app_service.dart';
import 'package:kermaneno/utils/cached_image.dart';
import 'package:kermaneno/utils/next_screen.dart';
import 'package:kermaneno/widgets/video_icon.dart';

class FeatureCard extends StatelessWidget {
  final Article article;
  final String heroTag;
  const FeatureCard({Key? key, required this.article, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Stack(
            children: <Widget>[
              Hero(
                tag: heroTag,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 10,
                                offset: Offset(0, 3))
                          ]),
                      child:
                          CustomCacheImage(imageUrl: article.image, radius: 5),
                    ),
                    VideoIcon(
                      tags: article.tags,
                      iconSize: 80,
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppService.getNormalText(article.title!),
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(CupertinoIcons.time,
                                size: 16, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            Text(article.timeAgo!,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13))
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
        onTap: () => navigateToDetailsScreen(context, article, heroTag));
  }
}
