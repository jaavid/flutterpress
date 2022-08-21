import 'package:easy_localization/easy_localization.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kermaneno/config/wp_config.dart';
import 'package:shamsi_date/shamsi_date.dart';

class Article {
  final int? id;
  final String? title;
  final String? content;
  final String? image;
  final String? video;
  final String? author;
  final String? avatar;
  final String? category;
  final String? date;
  final String? timeAgo;
  final String? link;
  final int? catId;
  final List? tags;
  String format(Date d) {
    final f = d.formatter;
    return '${f.wN} ${f.d} ${f.mN} ${f.yyyy}';
  }

  Article(
      {this.id,
      this.title,
      this.content,
      this.image,
      this.video,
      this.author,
      this.avatar,
      this.category,
      this.date,
      this.timeAgo,
      this.link,
      this.catId,
      this.tags});

  factory Article.fromJson(Map<String, dynamic> json) {
    Jalali j = Jalali.fromDateTime(DateTime.parse(json["date"]));
    final f = j.formatter;
    String date = '${f.d} ${f.mN} ${f.yyyy}';

    Jiffy.locale("fa").then((value) {
      String timeAgo = Jiffy(json['date']).add(hours: 6).fromNow();
    });
    return Article(
        id: json['id'] ?? 0,
        title: json['title']['rendered'] ?? '',
        content: json['content']['rendered'] ?? '',
        image: json['custom']["featured_image"] != ""
            ? json['custom']["featured_image"]
            : WpConfig.randomPostFeatureImage,
        video: json['custom']['td_video'] ?? '',
        author: json['custom']['author']['name'] ?? '',
        avatar: json['custom']['author']['avatar'] ??
            'https://icon-library.com/images/avatar-icon/avatar-icon-27.jpg',
        date: date,
        //timeAgo: Jiffy(json["date"]).fromNow(),
        //Jiffy.locale("fa").then((value) {
        //     DateTime dateTime = Jiffy("10 Mart 2021 16:38", "dd MMMM yyyy hh:mm").dateTime;
        // });
        timeAgo: Jiffy(json['date']).add(hours: 6).fromNow(),
        link: json['link'] ?? 'empty',
        category: json["custom"]["categories"][0]["name"] ?? '',
        catId: json["custom"]["categories"][0]["cat_ID"] ?? 0,
        tags: json['tags']);
  }
}
