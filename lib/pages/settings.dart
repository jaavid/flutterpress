import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'favoutite_articles.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notification = false;

  @override
  void initState() {
    super.initState();
    checkNotificationSetting();
  }

  checkNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = prefs.getInt(key) ?? 0;
    if (value == 0) {
      setState(() {_notification = false;});
    } else {
      setState(() {_notification = true;});
    }
  }

  saveNotificationSetting(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = val ? 1 : 0;
    prefs.setInt(key, value);
    if (value == 1) {
      setState(() {_notification = true;});
    } else {
      setState(() {_notification = false;});
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('بیشتر', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Vazir'),),
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Image(image: AssetImage('assets/icon.png'), height: 50,)),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Text("اولین نسخه اپلیکیشن پایگاه خبری کرمان نو \n کدنویسی در قرنطینه خانگی \n جاوید مومنی", textAlign: TextAlign.center, style: TextStyle(height: 1.6, color: Colors.black87)),
            ),
            Divider(height: 10, thickness: 2,),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteArticles(),),);},
                  child: ListTile(
                    leading: Image.asset("assets/more/favourite.png", width: 30,),
                    title: Text('مورد پسندها'),
                    subtitle: Text("اخباری که ذخیره کردید"),
                  ),
                ),
                ListTile(
                  leading: Image.asset("assets/more/contact.png", width: 30,),
                  title: Text('تماس'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () async {
                            const url = 'https://kermaneno.com';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text("Kermaneno.com", style: TextStyle(color: Colors.black54),)),
                      FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () async {
                            const url = 'mailto:info@kermaneno.com';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text("info@kermaneno.com", style: TextStyle(color: Colors.black54),)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {Share.share('پایگاه خبری کرمان نو را ببینید : https://kermaneno.com');},
                  child: ListTile(
                    leading: Image.asset("assets/more/share.png", width: 30),
                    title: Text('همرسانی'),
                    subtitle: Text("کرمان نو را به دیگران معرفی کنید"),
                  ),
                ),
                ListTile(
                  leading: Image.asset("assets/more/notification.png", width: 30),
                  isThreeLine: true,
                  title: Text('اعلان‌ها'),
                  subtitle: Text("تغییر اعلان ها"),
                  trailing: Switch(onChanged: (val) async {await saveNotificationSetting(val);}, value: _notification),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
