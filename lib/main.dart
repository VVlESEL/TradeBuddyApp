import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/ui/analytics_ui.dart';
import 'package:trade_buddy/ui/login_ui.dart';
import 'package:trade_buddy/ui/settings_ui.dart';
import 'package:trade_buddy/ui/trades_ui.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trades_controller.dart';

bool _isLoaded = false;
bool _isSignedIn = false;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Trade Buddy",
    theme: ThemeData(),
    home: TradeBuddy(),
  ));
}

class TradeBuddy extends StatefulWidget {
  @override
  _TradeBuddyState createState() => _TradeBuddyState();
}

class _TradeBuddyState extends State<TradeBuddy> {
  int _menuIndex = 0;

  @override
  void initState() {
    super.initState();

    Auth.checkSignIn().then((b) async {
      //get all the trades from the db and store them in the db
      if(b) {
        await SettingsController.initialize();
        await TradesController.initialize();
      }

      //inform the ui that data is loaded
      setState(() {
        _isSignedIn = b;
        _isLoaded = true;
      });

      //enable offline caching
      FirebaseDatabase.instance.setPersistenceEnabled(true);
      if (b) {
        FirebaseDatabase.instance
            .reference()
            .child("user/${Auth.user.uid}/trades")
            .keepSynced(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoaded
        ? Center(child: CircularProgressIndicator())
        : (!_isSignedIn
            ? Login()
            : Scaffold(
                appBar: AppBar(
                  title: Text("Trade Buddy"),
                ),
                body: _getBody(),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _menuIndex,
                  onTap: (int index) {
                    setState(() {
                      _menuIndex = index;
                    });
                  }, //update body widget
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      title: Text("Trades"),
                      icon: Icon(Icons.format_list_numbered),
                    ),
                    BottomNavigationBarItem(
                      title: Text("Analytics"),
                      icon: Icon(Icons.multiline_chart),
                    ),
                    BottomNavigationBarItem(
                      title: Text("Settings"),
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
              ));
  }

  Widget _getBody() {
    switch (_menuIndex) {
      case 0:
        return Trades();
      case 1:
        return Analytics();
      case 2:
        return Settings();
      default:
        return Container();
    }
  }
}
