import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kermaneno/utils/toast.dart';

class CommentsBloc extends ChangeNotifier {
  List<String> _flagList = [];
  List<String> get flagList => _flagList;

  Future getFlagList() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _flagList = sp.getStringList('flag_list') ?? [];
    notifyListeners();
  }

  Future addToFlagList(
      context, int categoryId, int postId, int commentId) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String flagId = "$categoryId-$postId-$commentId";
    await getFlagList().then((value) async {
      List<String> a = _flagList;
      if (a.contains(flagId)) {
        openToast1(context, 'You have flagged this comment already');
      } else {
        a.add(flagId);
        await sp.setStringList('flag_list', a);
      }
    });
  }

  Future removeFromFlagList(
      context, int categoryId, int postId, int commentId) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String flagId = "$categoryId-$postId-$commentId";
    await getFlagList().then((value) async {
      List<String> a = _flagList;
      if (a.contains(flagId)) {
        a.remove(flagId);
        await sp.setStringList('flag_list', a);
      } else {
        debugPrint('not possible');
      }
    });
  }
}
