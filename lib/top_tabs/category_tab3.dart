import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kermaneno/blocs/category_tab3_bloc.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/cards/card1.dart';
import 'package:kermaneno/cards/card4.dart';
import 'package:kermaneno/utils/empty_image.dart';
import 'package:kermaneno/utils/loading_card.dart';
import 'package:kermaneno/widgets/loading_indicator_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryTab3 extends StatefulWidget {
  final int categoryId;
  final GlobalKey<ScaffoldState> scaffoldKey;

  CategoryTab3({Key? key, required this.categoryId, required this.scaffoldKey})
      : super(key: key);

  @override
  _CategoryTab3State createState() => _CategoryTab3State();
}

class _CategoryTab3State extends State<CategoryTab3> {
  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      if (context.read<CategoryTab3Bloc>().articles.isEmpty) {
        context.read<CategoryTab3Bloc>().fetchData(widget.categoryId, mounted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cb = context.watch<CategoryTab3Bloc>();

    return RefreshIndicator(
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      onRefresh: () async {
        cb.onReload(widget.categoryId, mounted);
      },
      child: cb.hasData == false
          ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                EmptyPageWithImage(
                    image: Config.noContentImage,
                    title: 'no contents found'.tr())
              ],
            )
          : ListView.separated(
              key: PageStorageKey(widget.categoryId),
              padding: EdgeInsets.all(15),
              physics: NeverScrollableScrollPhysics(),
              itemCount: cb.articles.length != 0 ? cb.articles.length + 1 : 5,
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 15,
              ),
              shrinkWrap: true,
              itemBuilder: (_, int index) {
                if (cb.articles.isEmpty && cb.hasData == true) {
                  return LoadingCard(height: 250);
                } else if (index < cb.articles.length) {
                  if (index.isEven) {
                    return Card4(
                        article: cb.articles[index],
                        heroTag: 'tab3$index',
                        scaffoldKey: widget.scaffoldKey);
                  } else {
                    return Card1(
                      article: cb.articles[index],
                      heroTag: 'tab3$index',
                      scaffoldKey: widget.scaffoldKey,
                    );
                  }
                }
                return Opacity(
                    opacity: cb.isLoading == true ? 1.0 : 0.0,
                    child: LoadingIndicatorWidget());
              },
            ),
    );
  }
}
