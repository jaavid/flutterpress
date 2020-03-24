import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kermaneno_app/common/constants.dart';
import 'package:kermaneno_app/models/Comment.dart';
import 'package:kermaneno_app/widgets/commentBox.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

import 'add_comment.dart';

Future<List<dynamic>> fetchComments(int id) async {
  try {
    var response = await http.get("$WORDPRESS_URL/wp-json/wp/v2/comments?post=" + id.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body).map((m) => Comment.fromJson(m)).toList();
    } else {
      throw "خطا در بارگزاری خبر";
    }
  } on SocketException {
    throw 'اتصال اینترنت برقرار نیست';
  }
}

class Comments extends StatefulWidget {
  final int commentId;
  Comments(this.commentId, {Key key}) : super(key: key);
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    int commentId = widget.commentId;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.close), color: Colors.redAccent, onPressed: () {Navigator.of(context).pop();},),
        title: const Text('نظرات',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Vazir')),
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              children: <Widget>[commentSection(fetchComments(commentId))]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddComment(commentId), fullscreenDialog: true,));
        },
        child: Icon(Icons.add_comment),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

Widget commentSection(Future<List<dynamic>> comments) {
  return FutureBuilder<List<dynamic>>(
    future: comments,
    builder: (context, commentSnapshot) {
      if (commentSnapshot.hasData) {
        if (commentSnapshot.data.length == 0)
          return
            Directionality(textDirection: TextDirection.rtl,
                child: Container(height: 500, alignment: Alignment.center, child: Text("دیدگاهی ثبت نشده.\nاولین نظر را شما ثبت کنید.", textAlign: TextAlign.center,),)
            );
        return Column( children: commentSnapshot.data.map((item) {
          return InkWell(
            onTap: () {},
            child: commentBox(context, item.author, item.avatar, item.content),
          );
        }).toList());
      } else if (commentSnapshot.hasError) {
        return Container(
            height: 500,
            alignment: Alignment.center,
            child: Text("${commentSnapshot.error}"));
      }
      return Container(
        alignment: Alignment.center,
        height: 400,
        child: Loading(indicator: BallBeatIndicator(), size: 60.0, color: Theme.of(context).accentColor),
      );
    },
  );
}
