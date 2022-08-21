import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kermaneno/blocs/ads_bloc.dart';
import 'package:kermaneno/blocs/category_bloc.dart';
import 'package:kermaneno/blocs/notification_bloc.dart';
import 'package:kermaneno/blocs/settings_bloc.dart';
import 'package:kermaneno/blocs/user_bloc.dart';
import 'package:kermaneno/config/ad_config.dart';
import 'package:kermaneno/services/app_service.dart';
import 'package:kermaneno/services/notification_service.dart';
import 'package:kermaneno/tabs/profile_tab.dart';
import 'package:kermaneno/tabs/search_tab.dart';
import 'package:kermaneno/tabs/video_tab.dart';
import 'package:kermaneno/utils/snacbar.dart';
import '../tabs/bookmark_tab.dart';
import '../tabs/home_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  PageController? _pageController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<IconData> iconList = [
    Feather.home,
    Feather.youtube,
    Feather.search,
    Feather.heart,
    Feather.user
  ];

  _initData() async {
    await AppService().checkInternet().then((bool? hasInternet) {
      if (hasInternet != null && hasInternet == true) {
        context.read<CategoryBloc>().fetchData().then((value) =>
            NotificationService().initFirebasePushNotification(context).then(
                (_) => context
                        .read<NotificationBloc>()
                        .checkSubscription()
                        .then((value) {
                      if (AdConfig.isAdsEnabled) {
                        AdConfig().initAdmob().then(
                            (value) => context.read<AdsBloc>().initiateAds());
                      }
                    })));
      } else {
        openSnacbar(scaffoldKey, 'no internet'.tr());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initData();

    Future.microtask(() {
      context.read<SettingsBloc>().getPackageInfo();
      if (!context.read<UserBloc>().guestUser) {
        context.read<UserBloc>().getUserData();
      }
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController!.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  Future _onWillPop() async {
    if (selectedIndex != 0) {
      setState(() => selectedIndex = 0);
      _pageController!.animateToPage(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onWillPop(),
      child: Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: _bottonNavigationBar(context),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          allowImplicitScrolling: false,
          controller: _pageController,
          children: <Widget>[
            HomeTab(),
            VideoTab(),
            SearchTab(),
            BookmarkTab(),
            SettingPage()
          ],
        ),
      ),
    );
  }

  AnimatedBottomNavigationBar _bottonNavigationBar(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: iconList,
      gapLocation: GapLocation.none,
      activeIndex: selectedIndex,
      iconSize: 22,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      inactiveColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: (index) => onItemTapped(index),
    );
  }
}
