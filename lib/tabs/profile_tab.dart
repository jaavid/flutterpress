import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kermaneno/blocs/notification_bloc.dart';
import 'package:provider/provider.dart';
import 'package:kermaneno/blocs/settings_bloc.dart';
import 'package:kermaneno/blocs/theme_bloc.dart';
import 'package:kermaneno/blocs/user_bloc.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/config/wp_config.dart';
import 'package:kermaneno/pages/login.dart';
import 'package:kermaneno/pages/welcome.dart';
import 'package:kermaneno/services/app_service.dart';
import 'package:kermaneno/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/language.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin {
  void openLicenceDialog() {
    final SettingsBloc sb = Provider.of<SettingsBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (_) {
          return AboutDialog(
            applicationName: Config.appName,
            applicationVersion: sb.appVersion,
            applicationIcon: Image(
              image: AssetImage(Config.appIcon),
              height: 30,
              width: 30,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ub = context.watch<UserBloc>();
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 140,
          pinned: true,
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            title: Text('settings', style: TextStyle(color: Colors.white)).tr(),
            titlePadding: EdgeInsets.only(left: 20, bottom: 20, right: 20),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 15, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary),
                    child: !ub.isSignedIn ? GuestUserUI() : UserUI()),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'general settings',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.7,
                            wordSpacing: 1),
                      ).tr(),
                      SizedBox(height: 15),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 18,
                          child: Icon(
                            Feather.bell,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'get notifications',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Switch(
                            activeColor: Theme.of(context).primaryColor,
                            value:
                                context.watch<NotificationBloc>().subscribed!,
                            onChanged: (bool value) => context
                                .read<NotificationBloc>()
                                .configureFcmSubscription(value)),
                      ),
                      _Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 18,
                          child: Icon(
                            Icons.wb_sunny,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'dark mode',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Switch(
                            activeColor: Theme.of(context).primaryColor,
                            value: context.watch<ThemeBloc>().darkTheme!,
                            onChanged: (bool) {
                              context.read<ThemeBloc>().toggleTheme();
                            }),
                      ),
                      _Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.purpleAccent,
                          radius: 18,
                          child: Icon(
                            Feather.globe,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'language',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Icon(Feather.chevron_left),
                        onTap: () => nextScreenPopup(context, LanguagePopup()),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'social settings',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.7,
                            wordSpacing: 1),
                      ).tr(),
                      SizedBox(height: 15),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent[100],
                          radius: 18,
                          child: Icon(
                            Feather.mail,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'contact us',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Icon(Feather.chevron_left),
                        onTap: () => AppService().openEmailSupport(context),
                      ),
                      _Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 18,
                          child: Icon(
                            Feather.link,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'our website',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Icon(Feather.chevron_left),
                        onTap: () => AppService().openLinkWithCustomTab(
                            context, WpConfig.websiteUrl),
                      ),
                      _Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.pinkAccent,
                          radius: 18,
                          child: Icon(
                            Feather.video,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'Aparat',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Icon(Feather.chevron_left),
                        onTap: () => AppService()
                            .openLink(context, Config.aparatPageUrl),
                      ),
                      _Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple.shade900,
                          radius: 18,
                          child: Icon(
                            Feather.instagram,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'Instagram',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Icon(Feather.chevron_left),
                        onTap: () => AppService()
                            .openLink(context, Config.instagramPageUrl),
                      ),
                      _Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          radius: 18,
                          child: Icon(
                            Feather.youtube,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'youtube channel',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Icon(Feather.chevron_left),
                        onTap: () => AppService()
                            .openLink(context, Config.youtubeChannelUrl),
                      ),
                      _Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 18,
                          child: Icon(
                            Feather.twitter,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'twitter',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Icon(Feather.chevron_left),
                        onTap: () =>
                            AppService().openLink(context, Config.twitterUrl),
                      ),
                      _Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.pinkAccent,
                          radius: 18,
                          child: Icon(
                            Feather.star,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          'rate this app',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Icon(Feather.chevron_left),
                        onTap: () => AppService().launchAppReview(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class _Divider extends StatelessWidget {
  const _Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
      thickness: 0.2,
      indent: 50,
      color: Colors.grey[400],
    );
  }
}

class GuestUserUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: Icon(
              Feather.user_plus,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            'login',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ).tr(),
          trailing: Icon(Feather.chevron_left),
          onTap: () => nextScreenPopup(
              context,
              LoginPage(
                popUpScreen: true,
              )),
        ),
      ],
    );
  }
}

class UserUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBloc ub = context.watch<UserBloc>();
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: Icon(
              Feather.user_check,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.name!,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        _Divider(),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent[100],
            radius: 18,
            child: Icon(
              Feather.mail,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.email!,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        _Divider(),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.redAccent[100],
            radius: 18,
            child: Icon(
              Feather.log_out,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            'logout',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ).tr(),
          trailing: Icon(Feather.chevron_left),
          onTap: () => openLogoutDialog(context),
        ),
      ],
    );
  }

  openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('logout description').tr(),
            title: Text('logout title').tr(),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    _handleLogout(context);
                  },
                  child: Text('logout').tr()),
            ],
          );
        });
  }

  Future _handleLogout(context) async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    await ub
        .userSignout()
        .then((value) => nextScreenCloseOthers(context, WelcomePage()));
  }
}
