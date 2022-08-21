import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kermaneno/cards/custom_notification_card.dart';
import 'package:kermaneno/cards/post_notification_card.dart';
import 'package:kermaneno/config/config.dart';
import 'package:kermaneno/models/constants.dart';
import 'package:kermaneno/models/notification_model.dart';
import 'package:kermaneno/services/notification_service.dart';
import 'package:kermaneno/utils/empty_image.dart';
import 'package:easy_localization/easy_localization.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationList = Hive.box(Constants.notificationTag);

    void _openClearAllDialog() {
      showModalBottomSheet(
          elevation: 2,
          enableDrag: true,
          isDismissible: true,
          isScrollControlled: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(20),
              height: 210,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'clear all notification-dialog',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                        wordSpacing: 1),
                  ).tr(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.resolveWith(
                                (states) => Size(100, 50)),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Theme.of(context).primaryColor),
                            shape: MaterialStateProperty.resolveWith(
                                (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ))),
                        onPressed: () {
                          NotificationService().deleteAllNotificationData();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.resolveWith(
                                (states) => Size(100, 50)),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey[400]),
                            shape: MaterialStateProperty.resolveWith(
                                (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ))),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('notifications').tr(),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _openClearAllDialog(),
            child: Text('clear all').tr(),
            style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith(
                    (states) => EdgeInsets.only(right: 15, left: 15))),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: notificationList.listenable(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                List items = notificationList.values.toList();
                items.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
                if (items.isEmpty)
                  return EmptyPageWithImage(
                    image: Config.notificationImage,
                    title: 'no notification title'.tr(),
                    description: 'no notification description'.tr(),
                  );
                return _NotificationList(items: items);
              }),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List items;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 30),
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(
          height: 15,
        ),
        itemBuilder: (BuildContext context, int index) {
          final NotificationModel notificationModel = NotificationModel(
            timestamp: items[index]['timestamp'],
            date: items[index]['date'],
            title: items[index]['title'],
            body: items[index]['body'],
            postID: items[index]['post_id'] == null
                ? null
                : int.parse(items[index]['post_id']),
            thumbnailUrl: items[index]['image'],
          );

          final String timeAgo = Jiffy(notificationModel.date).fromNow();

          if (notificationModel.postID == null) {
            return CustomNotificationCard(
                notificationModel: notificationModel, timeAgo: timeAgo);
          } else {
            return PostNotificationCard(
              notificationModel: notificationModel,
              timeAgo: timeAgo,
            );
          }
        },
      ),
    );
  }
}
