import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabIndexBloc extends ChangeNotifier {

  

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;


  setTabIndex (newIndex)async{
    _tabIndex = newIndex;
    notifyListeners();
  }


}
