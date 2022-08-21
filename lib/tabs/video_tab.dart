import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/config/wp_config.dart';
import 'package:kermaneno/models/article.dart';
import 'package:http/http.dart' as http;
import 'package:kermaneno/cards/card3.dart';
import 'package:kermaneno/utils/empty_image.dart';
import 'package:kermaneno/utils/loading_card.dart';
import 'package:kermaneno/widgets/loading_indicator_widget.dart';

class VideoTab extends StatefulWidget {
  VideoTab({Key? key}) : super(key: key);

  @override
  _VideoTabState createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab>
    with AutomaticKeepAliveClientMixin {
  List<Article> _articles = [];
  ScrollController? _controller;
  int _page = 1;
  bool? _loading;
  bool? _hasData;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int _postAmount = 10;

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);
    _fetchArticles(1);
    _hasData = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future _fetchArticles(int page) async {
    try {
      var response =
          await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/posts?"
                  'page=$_page' +
              '&tags=${WpConfig.videoTagId}' +
              '&per_page=$_postAmount'));

      if (this.mounted) {
        if (response.statusCode == 200) {
          List? decodedData = jsonDecode(response.body);
          setState(() {
            _articles
                .addAll(decodedData!.map((m) => Article.fromJson(m)).toList());
            _loading = false;
            if (_articles.length == 0) {
              _hasData = false;
            }
          });
        }
      }
    } on SocketException {
      throw 'No Internet connection';
    }
  }

  _scrollListener() async {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd && _articles.isNotEmpty) {
      setState(() {
        _page += 1;
        _loading = true;
      });
      await _fetchArticles(_page).then((value) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  Future _onRefresh() async {
    setState(() {
      _loading = null;
      _articles.clear();
      _hasData = true;
      _page = 1;
    });
    await _fetchArticles(_page);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('video contents').tr(),
        actions: [
          IconButton(
            icon: Icon(
              Feather.rotate_cw,
              size: 22,
            ),
            onPressed: () async => await _onRefresh(),
          )
        ],
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        onRefresh: () async => await _onRefresh(),
        child: SingleChildScrollView(
          controller: _controller,
          child: _hasData == false
              ? Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.80,
                  width: double.infinity,
                  child: EmptyPageWithImage(
                      image: Config.noContentImage,
                      title: 'no contents found'.tr()),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView.separated(
                      itemCount: _articles.isEmpty ? 6 : _articles.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(15),
                      separatorBuilder: (ctx, inx) => SizedBox(
                        height: 15,
                      ),
                      itemBuilder: (context, index) {
                        if (_articles.isEmpty && _hasData == true) {
                          return LoadingCard(height: 280);
                        }

                        return Card3(
                            article: _articles[index],
                            heroTag: 'video${_articles[index].id}',
                            scaffoldKey: scaffoldKey);
                      },
                    ),
                    Opacity(
                        opacity: _loading == true ? 1.0 : 0.0,
                        child: LoadingIndicatorWidget())
                  ],
                ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
