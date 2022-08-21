import 'dart:convert';
import 'package:kermaneno/config/wp_config.dart';
import 'package:kermaneno/models/article.dart';
import 'package:kermaneno/models/comment.dart';
import 'package:http/http.dart' as http;

class WordPressService {
  Future fetchPostsByCategoryIdExceptPostId(
      int? postId, int? catId, int contentAmount) async {
    var response = await http.get(Uri.parse(
        "${WpConfig.websiteUrl}/wp-json/wp/v2/posts?exclude=$postId&categories[]=$catId&per_page=$contentAmount"));
    List? decodedData = jsonDecode(response.body);
    List<Article>? articles;

    if (response.statusCode == 200) {
      articles = decodedData!.map((m) => Article.fromJson(m)).toList();
    }
    return articles;
  }

  Future fetchPostsBySearch(String searchText) async {
    var response = WpConfig.blockedCategoryIds.isEmpty
        ? await http.get(Uri.parse(
            "${WpConfig.websiteUrl}/wp-json/wp/v2/posts?per_page=30&search=$searchText"))
        : await http.get(Uri.parse(
            "${WpConfig.websiteUrl}/wp-json/wp/v2/posts?per_page=30&search=$searchText&categories_exclude=" +
                WpConfig.blockedCategoryIds));
    List? decodedData = jsonDecode(response.body);
    List<Article>? articles;

    if (response.statusCode == 200) {
      articles = decodedData!.map((m) => Article.fromJson(m)).toList();
    }
    return articles;
  }

  Future fetchCommentsById(int? id) async {
    List<CommentModel> _comments = [];
    var response = await http.get(Uri.parse(
        "${WpConfig.websiteUrl}/wp-json/wp/v2/comments?per_page=100&post=" +
            id.toString()));
    List? decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      _comments = decodedData!.map((m) => CommentModel.fromJson(m)).toList();
    }
    return _comments;
  }

  Future<bool> postComment(
      int? id, String? name, String email, String comment) async {
    try {
      var response = await http.post(
          Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/comments"),
          body: {
            "author_email": email.trim().toLowerCase(),
            "author_name": name,
            "content": comment,
            "post": id.toString()
          });

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to post comment');
    }
  }
}
