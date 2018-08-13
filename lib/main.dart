import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/ui/analytics.dart';
import 'package:trade_buddy/ui/login.dart';
import 'package:trade_buddy/ui/settings.dart';
import 'package:trade_buddy/ui/trades.dart';
import 'package:trade_buddy/utils/auth.dart';

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
  bool _isLoaded = false;
  bool _isSignedIn = false;
  int _menuIndex = 0;

  @override
  void initState() {
    super.initState();

    Auth.checkSignIn().then((b) {
      setState(() {
        //enable offline caching
        FirebaseDatabase.instance.setPersistenceEnabled(true);
        FirebaseDatabase.instance
            .reference()
            .child("user/${Auth.user.uid}/trades")
            .keepSynced(true);

        _isSignedIn = b;
        _isLoaded = true;
      });
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
