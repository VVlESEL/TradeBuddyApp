import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/utils/settings_controller.dart';

///static class that holds all the filter settings
class FilterController {
  static DatabaseReference _reference;

  ///The function initializes the controller
  static Future<void> initialize() async {
    var currentAccount = SettingsController.currentAccount;
    if (currentAccount == null) return;

    _reference = FirebaseDatabase.instance.reference().child(
        "user/${Auth.user.uid}/accounts/$currentAccount");
  }

    static Future<void> updateGeneralFilter(Map generalFilter) async {
      //update buy and sell filter
      SettingsController.generalFilter = generalFilter;
  }
  static Future<void> updateStrategies(Map symbols) async {
    symbols.forEach((k,v) async {
        _reference.child("strategies").update({
          k: v["filter"],
        });
    });
  }
  static Future<void> updateSymbols(Map strategies) async {
    strategies.forEach((k,v) async {
      _reference.child("symbols").update({
        k: v["filter"],
      });
    });
  }
}
