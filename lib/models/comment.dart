import 'package:jiffy/jiffy.dart';

class CommentModel {
  final int? id;
  final String? author;
  final String? avatar;
  final String? content;
  final String? date;

  CommentModel({this.id, this.author, this.avatar, this.content, this.date});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      author: json['author_name'],
      avatar: json['author_avatar_urls']["48"] ?? "https://icon-library.com/images/avatar-icon/avatar-icon-27.jpg",
      content: json["content"]["rendered"],
      //date: Jiffy(json["date"]).fromNow(),
      date: Jiffy(json['date']).add(hours: 6).fromNow(),
    );
  }



  
}
