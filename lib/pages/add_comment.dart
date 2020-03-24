import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kermaneno_app/common/constants.dart';
import 'package:http/http.dart' as http;

Future<bool> postComment(
    int id, String name, String email, String website, String comment) async {
  try {
    var response =
        await http.post("$WORDPRESS_URL/wp-json/wp/v2/comments", body: {
      "author_email": email.trim().toLowerCase(),
      "author_name": name,
      "author_website": website,
      "content": comment,
      "post": id.toString()
    });

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  } catch (e) {
    throw Exception('خطا در ارسال دیدگاه');
  }
}

class AddComment extends StatefulWidget {
  final int commentId;

  AddComment(this.commentId, {Key key}) : super(key: key);
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _email = "";
  String _website = "";
  String _comment = "";

  @override
  Widget build(BuildContext context) {
    int commentId = widget.commentId;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            color: Colors.redAccent,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('نظر شما چیست؟',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Vazir')),
          elevation: 5,
          backgroundColor: Colors.white,
        ),
        body: Builder(builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(24, 36, 24, 36),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'نام *',
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'لطفا نام خود را وارد کنید.';
                                  }
                                  return null;
                                },
                                onSaved: (String val) {
                                  _name = val;
                                }),
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'ایمیل *',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'لطفا ایمیل خود را وارد کنید.';
                                  }
                                  return null;
                                },
                                onSaved: (String val) {
                                  _email = val;
                                }),
                            TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'وب سایت',
                                ),
                                onSaved: (String val) {
                                  _website = val;
                                }),
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'دیدگاه *',
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'نظر خود را بنویسید.';
                                  }
                                  return null;
                                },
                                onSaved: (String val) {
                                  _comment = val;
                                }),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 36.0),
                              height: 120,
                              child: RaisedButton.icon(
                                icon: Icon(Icons.check, color: Colors.white),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    postComment(commentId, _name, _email,
                                            _website, _comment)
                                        .then((back) {
                                      if (back) {
                                        Navigator.of(context).pop();
                                      } else {
                                        final snackBar = SnackBar(
                                            content: Text(
                                                'خطا در ثبت دیدگاه، مجددا تلاش کنید.'));
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });
                                  }
                                },
                                label: Text(
                                  'ارسال',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Text(
                              "دیدگاه شما پس از تایید مدیران منتشر خواهد شد.",
                              textAlign: TextAlign.center,
                            )
                          ],
                        ) // Build this out in the next steps.
                        ),
                  ),
                ),
              ));
        }));
  }
}
