import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kermaneno/blocs/category_tab1_bloc.dart';
import 'package:kermaneno/blocs/comment_bloc.dart';
import 'package:kermaneno/blocs/tab_index_bloc.dart';
import 'package:kermaneno/pages/splash.dart';
import 'blocs/ads_bloc.dart';
import 'blocs/category_bloc.dart';
import 'blocs/category_tab2_bloc.dart';
import 'blocs/category_tab3_bloc.dart';
import 'blocs/category_tab4_bloc.dart';
import 'blocs/featured_bloc.dart';
import 'blocs/latest_articles_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/popular_articles_bloc.dart';
import 'blocs/settings_bloc.dart';
import 'blocs/theme_bloc.dart';
import 'blocs/user_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'models/theme.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseObserver =
    FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: Consumer<ThemeBloc>(
        builder: (_, mode, child) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsBloc>(
                    create: (context) => SettingsBloc()),
                ChangeNotifierProvider<CategoryBloc>(
                    create: (context) => CategoryBloc()),
                ChangeNotifierProvider<FeaturedBloc>(
                    create: (context) => FeaturedBloc()),
                ChangeNotifierProvider<LatestArticlesBloc>(
                    create: (context) => LatestArticlesBloc()),
                ChangeNotifierProvider<UserBloc>(
                    create: (context) => UserBloc()),
                ChangeNotifierProvider<NotificationBloc>(
                    create: (context) => NotificationBloc()),
                ChangeNotifierProvider<PopularArticlesBloc>(
                    create: (context) => PopularArticlesBloc()),
                ChangeNotifierProvider<AdsBloc>(create: (context) => AdsBloc()),
                ChangeNotifierProvider<TabIndexBloc>(
                    create: (context) => TabIndexBloc()),
                ChangeNotifierProvider<CategoryTab1Bloc>(
                    create: (context) => CategoryTab1Bloc()),
                ChangeNotifierProvider<CategoryTab2Bloc>(
                    create: (context) => CategoryTab2Bloc()),
                ChangeNotifierProvider<CategoryTab3Bloc>(
                    create: (context) => CategoryTab3Bloc()),
                ChangeNotifierProvider<CategoryTab4Bloc>(
                    create: (context) => CategoryTab4Bloc()),
                ChangeNotifierProvider<CommentsBloc>(
                    create: (context) => CommentsBloc()),
              ],
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  navigatorObservers: [firebaseObserver],
                  locale: context.locale,
                  theme: ThemeModel().lightTheme,
                  darkTheme: ThemeModel().darkTheme,
                  themeMode:
                      mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
                  home: SplashPage()));
        },
      ),
    );
  }
}
