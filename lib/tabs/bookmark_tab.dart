import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kermaneno/cards/bookmark_card.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/models/article.dart';
import 'package:kermaneno/models/constants.dart';
import 'package:kermaneno/services/bookmark_service.dart';
import 'package:kermaneno/utils/empty_image.dart';
import 'package:easy_localization/easy_localization.dart';

class BookmarkTab extends StatefulWidget {
  const BookmarkTab({Key? key}) : super(key: key);

  @override
  _BookmarkTabState createState() => _BookmarkTabState();
}

class _BookmarkTabState extends State<BookmarkTab>
    with AutomaticKeepAliveClientMixin {
  void _openCLearAllDialog() {
    showModalBottomSheet(
        elevation: 2,
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            height: 210,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'clear all bookmark-dialog',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      wordSpacing: 1),
                ).tr(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith(
                              (states) => Size(100, 50)),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Theme.of(context).primaryColor),
                          shape: MaterialStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ))),
                      onPressed: () {
                        BookmarkService().clearBookmarkList();
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith(
                              (states) => Size(100, 50)),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.grey[400]),
                          shape: MaterialStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ))),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bookmarkList = Hive.box(Constants.bookmarkTag);
    return Scaffold(
      appBar: AppBar(
        title: Text('bookmarks').tr(),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => _openCLearAllDialog(),
            child: Text('clear all').tr(),
            style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith(
                    (states) => EdgeInsets.only(right: 15, left: 15))),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: bookmarkList.listenable(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  if (bookmarkList.isEmpty)
                    return EmptyPageWithImage(
                      image: Config.bookmarkImage,
                      title: 'bookmark is empty'.tr(),
                      description: 'save your favourite contents here'.tr(),
                    );

                  return ListView.separated(
                    padding: EdgeInsets.all(15),
                    itemCount: bookmarkList.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 15,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      Article article = Article(
                          id: bookmarkList.getAt(index)['id'],
                          title: bookmarkList.getAt(index)['title'],
                          content: bookmarkList.getAt(index)['content'],
                          image: bookmarkList.getAt(index)['image'],
                          video: bookmarkList.getAt(index)['video'],
                          author: bookmarkList.getAt(index)['author'],
                          avatar: bookmarkList.getAt(index)['avatar'],
                          category: bookmarkList.getAt(index)['category'],
                          date: bookmarkList.getAt(index)['date'],
                          timeAgo: bookmarkList.getAt(index)['time_ago'],
                          link: bookmarkList.getAt(index)['link'],
                          catId: bookmarkList.getAt(index)['catId'],
                          tags: bookmarkList.getAt(index)['tags']);

                      return BookmarkCard(article: article);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
