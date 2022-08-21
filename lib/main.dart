import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'models/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox(Constants.bookmarkTag);
  await Hive.openBox(Constants.resentSearchTag);
  await Hive.openBox(Constants.notificationTag);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));

  runApp(EasyLocalization(
    supportedLocales: [Locale('fa'), Locale('en')],
    path: 'assets/translations',
    fallbackLocale: Locale('fa'),

    //Defaut language
    startLocale: Locale('fa'),
    useOnlyLangCode: true,
    child: MyApp(),
  ));
}
