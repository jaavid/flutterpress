import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kermaneno/blocs/category_tab1_bloc.dart';
import 'package:kermaneno/blocs/category_tab2_bloc.dart';
import 'package:kermaneno/blocs/category_tab3_bloc.dart';
import 'package:kermaneno/blocs/category_tab4_bloc.dart';
import 'package:kermaneno/blocs/latest_articles_bloc.dart';
import 'package:kermaneno/blocs/tab_index_bloc.dart';
import 'package:kermaneno/config/wp_config.dart';
import 'package:kermaneno/top_tabs/category_tab1.dart';
import 'package:kermaneno/top_tabs/category_tab2.dart';
import 'package:kermaneno/top_tabs/category_tab3.dart';
import 'package:kermaneno/top_tabs/category_tab4.dart';
import 'package:kermaneno/top_tabs/tab0.dart';

class TabMedium extends StatefulWidget {
  final ScrollController sc;
  final TabController tc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  TabMedium(
      {Key? key, required this.sc, required this.tc, required this.scaffoldKey})
      : super(key: key);

  @override
  _TabMediumState createState() => _TabMediumState();
}

class _TabMediumState extends State<TabMedium> {
  @override
  void initState() {
    super.initState();
    this.widget.sc.addListener(_scrollListener);
  }

  void _scrollListener() async {
    final lb = context.read<LatestArticlesBloc>();
    final cb1 = context.read<CategoryTab1Bloc>();
    final cb2 = context.read<CategoryTab2Bloc>();
    final cb3 = context.read<CategoryTab3Bloc>();
    final cb4 = context.read<CategoryTab4Bloc>();
    final sb = context.read<TabIndexBloc>();
    var isEnd =
        this.widget.sc.offset >= this.widget.sc.position.maxScrollExtent &&
            !this.widget.sc.position.outOfRange;

    if (sb.tabIndex == 0) {
      if (lb.articles.isNotEmpty && isEnd) {
        debugPrint("reached the bottom -t0");
        lb.pageIncreament();
        lb.setLoading(true);
        await lb.fetchData().then((value) {
          lb.setLoading(false);
        });
      }
    } else if (sb.tabIndex == 1) {
      if (isEnd) {
        debugPrint("reached the bottom -t1");
        cb1.pageIncreament();
        cb1.setLoading(true);
        await cb1
            .fetchData(WpConfig.selectedCategories['1'][0], mounted)
            .then((value) {
          cb1.setLoading(false);
        });
      }
    } else if (sb.tabIndex == 2) {
      if (isEnd) {
        debugPrint("reached the bottom -t2");
        cb2.pageIncreament();
        cb2.setLoading(true);
        await cb2
            .fetchData(WpConfig.selectedCategories['2'][0], mounted)
            .then((value) {
          cb2.setLoading(false);
        });
      }
    } else if (sb.tabIndex == 3) {
      if (isEnd) {
        debugPrint("reached the bottom -t3");
        cb3.pageIncreament();
        cb3.setLoading(true);
        await cb3
            .fetchData(WpConfig.selectedCategories['3'][0], mounted)
            .then((value) {
          cb3.setLoading(false);
        });
      }
    } else if (sb.tabIndex == 4) {
      if (isEnd) {
        debugPrint("reached the bottom -t4");
        cb4.pageIncreament();
        cb4.setLoading(true);
        await cb4
            .fetchData(WpConfig.selectedCategories['4'][0], mounted)
            .then((value) {
          cb4.setLoading(false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        Tab0(
          scaffoldKey: widget.scaffoldKey,
        ),
        CategoryTab1(
          categoryId: WpConfig.selectedCategories['1'][0],
          scaffoldKey: widget.scaffoldKey,
        ),
        CategoryTab2(
          categoryId: WpConfig.selectedCategories['2'][0],
          scaffoldKey: widget.scaffoldKey,
        ),
        CategoryTab3(
          categoryId: WpConfig.selectedCategories['3'][0],
          scaffoldKey: widget.scaffoldKey,
        ),
        CategoryTab4(
          categoryId: WpConfig.selectedCategories['4'][0],
          scaffoldKey: widget.scaffoldKey,
        ),
      ],
      controller: widget.tc,
    );
  }
}
