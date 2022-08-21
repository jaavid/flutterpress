import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:kermaneno/blocs/user_bloc.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/pages/create_account.dart';
import 'package:kermaneno/pages/done.dart';
import 'package:kermaneno/pages/login.dart';
import 'package:kermaneno/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kermaneno/widgets/language.dart';
import '../config/config.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _onSkipPressed() async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    await ub.loginAsGuestUser().then((_) {
      nextScreen(context, DonePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            actions: [
              TextButton(
                style: ButtonStyle(),
                child: Text(
                  'skip',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ).tr(),
                onPressed: () => _onSkipPressed(),
              ),
              IconButton(
                alignment: Alignment.center,
                padding: EdgeInsets.all(0),
                iconSize: 18,
                icon: Icon(Feather.globe),
                onPressed: () {
                  nextScreenPopup(context, LanguagePopup());
                },
              ),
            ],
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage(Config.splash),
                        height: 130,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'welcome to',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ).tr(),
                              SizedBox(
                                width: 5,
                              ),
                              Image(
                                image: AssetImage(Config.logo),
                                height: 40,
                                width: 160,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, top: 15),
                            child: Text(
                              'welcome-intro',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ).tr(),
                          )
                        ],
                      ),
                    ],
                  )),
              Spacer(),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: 45,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith((states) =>
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Theme.of(context).primaryColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "login to continue",
                              style: TextStyle(
                                  letterSpacing: -0.7,
                                  wordSpacing: 1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ).tr(),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Feather.arrow_right,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPressed: () => nextScreen(context, LoginPage()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "don't have an account?",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary),
                        ).tr(),
                        TextButton(
                          child: Text(
                            'create',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                          ).tr(),
                          onPressed: () =>
                              nextScreen(context, CreateAccountPage()),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
