import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/ui/analytics/analytics_ui.dart';
import 'package:trade_buddy/ui/login_ui.dart';
import 'package:trade_buddy/ui/settings_ui.dart';
import 'package:trade_buddy/ui/trades_ui.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trades_controller.dart';
import 'package:trade_buddy/utils/admob.dart';
import 'dart:async';

bool isLoaded = false;
bool isSignedIn = false;

void main() {
  FirebaseAdMob.instance.initialize(appId: getAdMobAppId());

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

class _TradeBuddyState extends State<TradeBuddy>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Timer _animationTimer;
  BannerAd _bannerAd;
  int _menuIndex = 0;

  @override
  void deactivate() {
    _bannerAd?.dispose()?.then((b) => _bannerAd = null);
    super.deactivate();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this,
    );

    _animationTimer = Timer.periodic(
      Duration(seconds: 20),
      (Timer t) async {
        await _animationController.forward().orCancel;
        await _animationController.reverse().orCancel;
      },
    );

    if (!isLoaded) {
      Auth.checkSignIn().then((b) async {
        //get all the trades from the db and store them in the db
        if (b) {
          await SettingsController.initialize();
          await TradesController.initialize();
        }

        //inform the ui that data is loaded
        setState(() {
          isSignedIn = b;
          isLoaded = true;
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
  }

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? Center(child: CircularProgressIndicator())
        : (!isSignedIn
            ? Login()
            : Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset(
                          "images/icon_bmtrading.png",
                        ),
                      ),
                      Text("Trade Buddy"),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: AnimatedStar(
                        controller: _animationController,
                      ),
                      onPressed: () => createInterstitialAd()
                        ..load()
                        ..show(
                          anchorType: AnchorType.top,
                          anchorOffset: 100.0,
                        ),
                    )
                  ],
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
        _bannerAd ??= createBannerAd()
          ..load().then((loaded) {
            if (loaded && this.mounted) {
              _bannerAd
                ..show(
                  anchorType: AnchorType.bottom,
                  anchorOffset: 60.0,
                );
            }
          });
        return Trades();
      case 1:
        _bannerAd?.dispose()?.then((b) => _bannerAd = null);
        return Analytics();
      case 2:
        _bannerAd?.dispose()?.then((b) => _bannerAd = null);
        return Settings();
      default:
        return Container();
    }
  }
}

class AnimatedStar extends StatelessWidget {
  final Animation<double> controller;
  final Animation<Color> color;
  final Animation<double> size;

  AnimatedStar({Key key, this.controller})
      : size = Tween<double>(
          begin: 40.0,
          end: 50.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0),
          ),
        ),
        color = ColorTween(
          begin: Colors.white,
          end: Colors.yellow[900],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          child: Icon(
            Icons.star,
            color: color.value,
            size: size.value,
          ),
        );
      },
    );
  }
}
