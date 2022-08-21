import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kermaneno/cards/card6.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/models/article.dart';
import 'package:kermaneno/models/constants.dart';
import 'package:kermaneno/services/app_service.dart';
import 'package:kermaneno/services/wordpress_service.dart';
import 'package:kermaneno/utils/empty_icon.dart';
import 'package:kermaneno/utils/empty_image.dart';
import 'package:kermaneno/utils/loading_card.dart';
import 'package:kermaneno/utils/snacbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var searchFieldCtrl = TextEditingController();
  bool _searchStarted = false;

  Future? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _searchBar(),
      ),
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        top: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              _searchStarted == false ? _suggestionUI() : _afterSearchUI()
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.transparent),
      child: TextFormField(
        autofocus: true,
        controller: searchFieldCtrl,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "search contents".tr(),
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: IconButton(
              padding: EdgeInsets.only(right: 10),
              icon: Icon(
                Icons.close,
                size: 22,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                setState(() {
                  _searchStarted = false;
                });
                searchFieldCtrl.clear();
              }),
        ),
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) {
          if (value == '' || value.isEmpty) {
            openSnacbar(scaffoldKey, 'Type something!');
          } else {
            setState(() => _searchStarted = true);
            data = WordPressService().fetchPostsBySearch(searchFieldCtrl.text);
            AppService().addToRecentSearchList(value);
          }
        },
      ),
    );
  }

  Widget _afterSearchUI() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: data,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return _LoadingWidget();
                case ConnectionState.done:
                default:
                  if (snapshot.hasError || snapshot.data == null) {
                    return EmptyPageWithIcon(
                        icon: Icons.error, title: 'Error!');
                  } else if (snapshot.data.isEmpty) {
                    return EmptyPageWithImage(
                      image: Config.noContentImage,
                      title: 'no contents found'.tr(),
                      description: 'try again'.tr(),
                    );
                  }

                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      separatorBuilder: (context, index) => SizedBox(
                            height: 15,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        Article article = snapshot.data[index];
                        return Card6(
                            article: article,
                            heroTag: 'search${article.id}',
                            scaffoldKey: scaffoldKey);
                      });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _suggestionUI() {
    final recentSearchs = Hive.box(Constants.resentSearchTag);
    return recentSearchs.isEmpty
        ? _EmptySearchAnimation()
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'recent searches'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                ValueListenableBuilder(
                  valueListenable: recentSearchs.listenable(),
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
                    return ListView.separated(
                      itemCount: recentSearchs.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 15,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: ListTile(
                              horizontalTitleGap: 5,
                              title: Text(
                                recentSearchs.getAt(index),
                                style: TextStyle(fontSize: 17),
                              ),
                              leading: Icon(
                                CupertinoIcons.time_solid,
                                color: Colors.grey[400],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => AppService()
                                    .removeFromRecentSearchList(index),
                              ),
                              onTap: () {
                                setState(() => _searchStarted = true);
                                searchFieldCtrl.text =
                                    recentSearchs.getAt(index);
                                data = WordPressService()
                                    .fetchPostsBySearch(searchFieldCtrl.text);
                              }),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
        itemBuilder: (BuildContext context, int index) {
          return LoadingCard(height: 110);
        });
  }
}

class _EmptySearchAnimation extends StatelessWidget {
  const _EmptySearchAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            height: 200,
            width: 200,
            child: FlareActor(
              Config.searchAnimation,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "search",
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
          ),
        ),
        Text(
          'search for contents',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.7,
              wordSpacing: 1),
        ).tr(),
        SizedBox(
          height: 10,
        ),
        Text(
          'search-description',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary),
        ).tr()
      ],
    );
  }
}
