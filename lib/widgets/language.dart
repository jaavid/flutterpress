import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../config/config.dart';

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({Key? key}) : super(key: key);

  @override
  _LanguagePopupState createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select language').tr(),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: Config.languages.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemList(Config.languages[index], index);
        },
      ),
    );
  }

  Widget _itemList(d, index) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Feather.globe,
            size: 22,
          ),
          horizontalTitleGap: 10,
          title: Text(
            d,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          onTap: () async {
            if (d == 'English') {
              await context.setLocale(Locale('en'));
            } else if (d == 'فارسی') {
              await context.setLocale(Locale('fa'));
            }
            Navigator.pop(context);
          },
        ),
        Divider(
          height: 0,
          indent: 50,
          color: Colors.grey[400],
        )
      ],
    );
  }
}
