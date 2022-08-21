import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kermaneno/blocs/user_bloc.dart';
import 'package:kermaneno/pages/home.dart';
import 'package:kermaneno/pages/welcome.dart';
import 'package:kermaneno/utils/next_screen.dart';
import '../config/config.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _afterSplash() async {
    final UserBloc ub = context.read<UserBloc>();
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      ub.isSignedIn == true || ub.guestUser == true
          ? _gotoHomePage()
          : _gotoWelcomePage();
    });
  }

  void _gotoHomePage() {
    nextScreenReplace(context, HomePage());
  }

  void _gotoWelcomePage() {
    nextScreenReplace(context, WelcomePage());
  }

  @override
  void initState() {
    _afterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffa61f23),
      body: Center(
        child: Image(
          height: 120,
          width: 120,
          image: AssetImage(Config.splash),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
