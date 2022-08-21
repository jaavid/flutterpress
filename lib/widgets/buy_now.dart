import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kermaneno/services/app_service.dart';

class BuyNowWidget extends StatelessWidget {
  const BuyNowWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.onPrimary),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            isThreeLine: false,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 20,
              child: Icon(
                Feather.shopping_cart,
                size: 20,
                color: Colors.white,
              ),
            ),
            title: Text(
              'buy now',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary),
            ).tr(),
            subtitle: Text(
              'buy now subtitle',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.secondary),
            ).tr(),
            trailing: Icon(Feather.chevron_right),
            onTap: () => AppService().openLinkWithCustomTab(context,
                "https://codecanyon.net/item/newsfreak-flutter-news-app-for-wordpress/32743254"),
          ),
        ),
      ],
    );
  }
}
