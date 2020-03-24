import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kermaneno_app/common/constants.dart';
import 'package:kermaneno_app/pages/articles.dart';
import 'package:kermaneno_app/pages/categories.dart';
import 'package:kermaneno_app/pages/local_articles.dart';
import 'package:kermaneno_app/pages/search.dart';
import 'package:kermaneno_app/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'کرمان نو',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF385C7B),
          accentColor: Color(0xFFE74C3C),
          textTheme: TextTheme(
              title: TextStyle(fontSize: 17, color: Colors.black, height: 1.2, fontWeight: FontWeight.w700, fontFamily: "Vazir"),
              //headline6: TextStyle(fontSize: 17, color: Colors.black, height: 1.2, fontWeight: FontWeight.w700, fontFamily: "Vazir"),
              caption: TextStyle(color: Colors.black45, fontSize: 10, fontFamily: "Vazir"),
              body1: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87,fontWeight: FontWeight.w100, fontFamily: "Vazir"),
              //bodyText2 : TextStyle(fontSize: 16, height: 1.5, color: Colors.black87,fontWeight: FontWeight.w100, fontFamily: "Vazir")
            ),
        ),
        home: Directionality(textDirection: TextDirection.rtl, child:MyHomePage())
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Firebase Cloud Messaging setup
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    Articles(),
    LocalArticles(),
    Categories(),
    Search(),
    Settings()
  ];

  @override
  void initState() {super.initState();}

  startFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = prefs.getInt(key) ?? 0;
    if (value == 1) {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(message["notification"]["title"], style: TextStyle(fontFamily: "Vazir", fontSize: 18)),
                content: Text(message["notification"]["body"]),
                actions: <Widget>[
                  FlatButton(child: new Text("لغو"), onPressed: () {Navigator.of(context).pop();}),
                ],
              );
            },
          );
        },
        onLaunch: (Map<String, dynamic> message) async {
          // print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          // print("onResume: $message");
        },
      );
      _firebaseMessaging.getToken().then((token) {
        // print("Firebase Token:" + token);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontFamily: "Vazir"),
          unselectedLabelStyle: TextStyle(fontFamily: "Vazir"),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('خانه')),
            BottomNavigationBarItem(icon: Icon(Icons.flare), title: Text(PAGE2_CATEGORY_NAME)),
            BottomNavigationBarItem(icon: Icon(Icons.category), title: Text('سرویس‌ها')),
            BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('جستجو')),
            BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text('بیشتر')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed),
    );
  }

  void _onItemTapped(int index) {
    setState(() {_selectedIndex = index;});
  }
}
