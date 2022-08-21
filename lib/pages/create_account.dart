import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:kermaneno/blocs/user_bloc.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/pages/done.dart';
import 'package:kermaneno/pages/login.dart';
import 'package:kermaneno/services/app_service.dart';
import 'package:kermaneno/services/auth_service.dart';
import 'package:kermaneno/utils/snacbar.dart';
import '../models/icon_data.dart';
import '../models/user.dart';
import '../utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({Key? key, this.popUpScreen}) : super(key: key);

  final bool? popUpScreen;

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var userNameCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  final _btnController = new RoundedLoadingButtonController();
  bool _checkboxTicked = false;

  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;

  void _onlockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon().lock;
      });
    }
  }

  Future _handleCreateUser() async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    if (userNameCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Username is required');
    } else if (emailCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Email is required');
    } else if (passwordCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Password is required');
    } else if (_checkboxTicked == false) {
      _btnController.reset();
      openSnacbar(
          scaffoldKey, 'Please accept the terms & conditions to continue');
    } else {
      AppService().checkInternet().then((hasInternet) async {
        if (!hasInternet!) {
          _btnController.reset();
          openSnacbar(scaffoldKey, 'no internet'.tr());
        } else {
          UserModel userModel = UserModel(
            userName: userNameCtrl.text,
            emailId: emailCtrl.text,
            password: passwordCtrl.text,
          );
          await AuthService.createUser(userModel)
              .then((UserResponseModel response) async {
            if (response.code == 200) {
              await ub
                  .guestUserSignout()
                  .then((value) => ub.saveUserData(userModel))
                  .then((value) => ub.setSignIn())
                  .then((value) {
                _btnController.success();
                afterSignUp();
              });
            } else {
              _btnController.reset();
              openSnacbar(scaffoldKey, response.message);
            }
          });
        }
      });
    }
  }

  void afterSignUp() async {
    if (widget.popUpScreen == null || widget.popUpScreen == false) {
      nextScreen(context, DonePage());
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'create account',
              style: TextStyle(
                  letterSpacing: -0.7,
                  wordSpacing: 1,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ).tr(),
            SizedBox(
              height: 15,
            ),
            Text(
              'follow the simple steps',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary),
            ).tr(),
            SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 1,
                      letterSpacing: -0.7),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 10, bottom: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter username',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          size: 20,
                        )),
                    controller: userNameCtrl,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Text(
                  'Email Address',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 1,
                      letterSpacing: -0.7),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 10, bottom: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter email address',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          size: 20,
                        )),
                    controller: emailCtrl,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Text(
                  'Password',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 1,
                      letterSpacing: -0.7),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                            icon: lockIcon, onPressed: () => _onlockPressed()),
                        prefixIcon: Icon(
                          Icons.lock,
                          size: 20,
                        )),
                    controller: passwordCtrl,
                    obscureText: offsecureText,
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _checkboxTicked,
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => Theme.of(context).primaryColor),
                        onChanged: (value) {
                          setState(() {
                            _checkboxTicked = value!;
                          });
                        },
                      ),
                      InkWell(
                        child: Text(
                          'accept terms',
                          style: TextStyle(color: Colors.blueAccent),
                        ).tr(),
                        onTap: () => AppService().openLinkWithCustomTab(
                            context, Config.privacyPolicyUrl),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                RoundedLoadingButton(
                  animateOnTap: true,
                  child: Wrap(
                    children: [
                      Text(
                        'create',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ).tr()
                    ],
                  ),
                  controller: _btnController,
                  onPressed: () => _handleCreateUser(),
                  width: MediaQuery.of(context).size.width * 1.0,
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "already have an account?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary),
                      ).tr(),
                      TextButton(
                          child: Text(
                            'login',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary),
                          ).tr(),
                          onPressed: () => nextScreenReplace(
                              context,
                              LoginPage(
                                popUpScreen: widget.popUpScreen,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
