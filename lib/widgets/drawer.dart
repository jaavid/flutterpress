import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kermaneno/blocs/settings_bloc.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/config/wp_config.dart';
import 'package:kermaneno/pages/category_based_articles.dart';
import 'package:kermaneno/services/app_service.dart';
import 'package:kermaneno/utils/next_screen.dart';
import '../blocs/category_bloc.dart';
import '../models/category.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final d = context.watch<CategoryBloc>().categoryData;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 250,
                width: double.infinity,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                      child: Image(
                          height: 40,
                          width: 180,
                          fit: BoxFit.contain,
                          image: AssetImage(Config.logo)),
                    ),
                    Text(
                        'App Version : ${context.watch<SettingsBloc>().appVersion}')
                  ],
                )),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  ListTile(
                    isThreeLine: false,
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Icons.email_outlined,
                      size: 22,
                    ),
                    horizontalTitleGap: 5,
                    title: Text(
                      'contact us',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      AppService().openEmailSupport(context);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Icons.link_outlined,
                      size: 22,
                    ),
                    horizontalTitleGap: 5,
                    title: Text(
                      'our website',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      AppService()
                          .openLinkWithCustomTab(context, WpConfig.websiteUrl);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Feather.facebook,
                      size: 22,
                    ),
                    horizontalTitleGap: 5,
                    title: Text(
                      'facebook page',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      AppService().openLink(context, Config.facebookPageUrl);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Feather.youtube,
                      size: 22,
                    ),
                    horizontalTitleGap: 5,
                    title: Text(
                      'youtube channel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      AppService().openLink(context, Config.youtubeChannelUrl);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Feather.twitter,
                      size: 22,
                    ),
                    horizontalTitleGap: 5,
                    title: Text(
                      'twitter',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      AppService().openLink(context, Config.twitterUrl);
                    },
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey[600],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Text(
                'categories',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 10, bottom: 30),
                itemCount: d.length,
                itemBuilder: (BuildContext context, int index) {
                  final String _thumbnail =
                      WpConfig.categoryThumbnails.keys.contains(d[index].id)
                          ? WpConfig.categoryThumbnails[d[index].id]
                          : WpConfig.randomCategoryThumbnail;

                  //subcategories removed from the category list
                  if (d[index].parent != 0) {
                    return Container();
                  }

                  return ExpansionTile(
                      tilePadding: EdgeInsets.only(left: 20, right: 15),
                      leading: CircleAvatar(
                        radius: 15,
                        backgroundImage: CachedNetworkImageProvider(_thumbnail),
                      ),
                      title: InkWell(
                        child: Text(
                          d[index].name!.toUpperCase(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          nextScreen(
                              context,
                              CategoryBasedArticles(
                                  categoryName: d[index].name,
                                  categoryId: d[index].id));
                        },
                      ),
                      initiallyExpanded: false,
                      childrenPadding: EdgeInsets.only(left: 20, right: 15),
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: d.length,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (BuildContext context1, int index1) {
                            Category subCategory = d[index1];
                            if (subCategory.parent == d[index].id) {
                              return ListTile(
                                title: Text(subCategory.name!),
                                horizontalTitleGap: 0,
                                leading: Icon(Feather.chevron_right),
                                onTap: () {
                                  Navigator.pop(context);
                                  nextScreen(
                                      context,
                                      CategoryBasedArticles(
                                          categoryName: subCategory.name,
                                          categoryId: subCategory.id));
                                },
                              );
                            }

                            return Container();
                          },
                        ),
                      ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
