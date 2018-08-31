import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/utils/settings_controller.dart';

///static class that holds all the filter settings
class FilterController {
  static DatabaseReference _reference;
  static List _filteredStrategies;
  static List _filteredSymbols;
  static bool _isBuy;
  static bool _isSell;

  ///The function initializes the controller
  static Future<void> initialize() async {
    var currentAccount = SettingsController.currentAccount;
    if (currentAccount == null) return;

    _reference = FirebaseDatabase.instance.reference().child(
        "user/${Auth.user.uid}/settings/accounts/$currentAccount/filter");

    //get initial settings
    var snapshot = await _reference.once();
    bool hasData = snapshot.value != null;
    //get all filtered settings for this account
    filteredStrategies = hasData
        ? snapshot.value["filtered_strategies"] ??
            SettingsController.strategies.values.toList()
        : SettingsController.strategies.values.toList();
    filteredSymbols = hasData
        ? snapshot.value["filtered_symbols"] ??
            SettingsController.symbols.keys.toList()
        : SettingsController.symbols.keys.toList();
    isBuy = hasData ? snapshot.value["is_buy"] : true;
    isSell = hasData ? snapshot.value["is_sell"] : true;
  }

  static bool get isBuy => _isBuy;

  static set isBuy(bool value) {
    print("isBuy = $value");
    if (isBuy == value) return;
    _isBuy = value;
    _reference.update({
      "is_buy": value,
    });
  }

  static bool get isSell => _isSell;

  static set isSell(bool value) {
    print("isSell = $value");
    if (isSell == value) return;
    _isSell = value;
    _reference.update({
      "is_sell": value,
    });
  }

  static List get filteredStrategies => _filteredStrategies;

  static set filteredStrategies(List value) {
    print("filteredStrategies = $value");
    if (filteredStrategies == value) return;
    _filteredStrategies = value;
    _reference.update({
      "filtered_strategies": value,
    });
  }

  static List get filteredSymbols => _filteredSymbols;

  static set filteredSymbols(List value) {
    print("filteredSymbols = $value");
    if (filteredSymbols == value) return;
    _filteredSymbols = value;
    _reference.update({
      "filtered_symbols": value,
    });
  }
}
