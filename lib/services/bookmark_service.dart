import 'package:hive/hive.dart';
import 'package:kermaneno/models/article.dart';
import 'package:kermaneno/models/constants.dart';
import 'package:kermaneno/utils/snacbar.dart';
import 'package:easy_localization/easy_localization.dart';

class BookmarkService {
  final bookmarkedList = Hive.box(Constants.bookmarkTag);

  Future handleBookmarkIconPressed(Article article, scaffoldKey) async {
    if (bookmarkedList.keys.contains(article.id)) {
      removeFromBookmarkList(article);
    } else {
      addToBookmarkList(article);
      openSnacbar(scaffoldKey, 'added to your bookamrk'.tr());
    }
  }

  Future addToBookmarkList(Article article) async {
    await bookmarkedList.put(article.id, {
      'id': article.id,
      'title': article.title,
      'content': article.content,
      'image': article.image,
      'video': article.video,
      'author': article.author,
      'avatar': article.avatar,
      'category': article.category,
      'date': article.date,
      'time_ago': article.timeAgo,
      'link': article.link,
      'catId': article.catId,
      'tags': article.tags ?? []
    });
  }

  Future removeFromBookmarkList(Article article) async {
    await bookmarkedList.delete(article.id);
  }

  Future clearBookmarkList() async {
    await bookmarkedList.clear();
  }
}
