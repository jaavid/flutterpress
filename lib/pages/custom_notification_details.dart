import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kermaneno/models/notification_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kermaneno/services/app_service.dart';
import 'package:kermaneno/widgets/html_body.dart';

class CustomNotificationDeatils extends StatelessWidget {
  const CustomNotificationDeatils({Key? key, required this.notificationModel})
      : super(key: key);

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    final String dateTime = Jiffy(notificationModel.date).fromNow();
    return Scaffold(
      appBar: AppBar(
        title: Text('notification details').tr(),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  AntDesign.clockcircleo,
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  dateTime,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              AppService.getNormalText(notificationModel.title!),
              style: TextStyle(
                  fontFamily: 'Vazir',
                  wordSpacing: 1,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 2,
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            HtmlBody(
                content: notificationModel.body!,
                isVideoEnabled: true,
                isimageEnabled: true,
                isIframeVideoEnabled: true),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
