import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/utils/settings_controller.dart';

///static class that holds all the filter settings
class FilterController {
  static DatabaseReference _reference;
  static DataSnapshot _filter;

  ///The function initializes the controller
  static Future<void> initialize() async {
    var currentAccount = SettingsController.currentAccount;
    if (currentAccount == null) return;

    _reference = FirebaseDatabase.instance.reference().child(
        "user/${Auth.user.uid}/settings/accounts/$currentAccount/filter");

    //get initial settings
    _filter = await _reference.once();

    //update filter, compare to strategies/symbols of settings controller
    await updateFilter();

    //get initial settings
    _filter = await _reference.once();
  }

  static Map get filter => _filter.value;

  static Future<void> updateFilter() async {
    //update buy and sell filter
    if (filter == null || filter["buy"] == null)
      _reference.update({
        "buy": true,
      });
    if (filter == null || filter["sell"] == null)
      _reference.update({
        "sell": true,
      });

    //update strategies filter
    if (filter == null ||
        filter["strategies"] == null ||
        filter["strategies"]["*"] == null) {
      _reference.child("strategies").update({
        "*": true,
      });
    }

    SettingsController.strategies.values.forEach((strategy) {
      if (filter == null ||
          filter["strategies"] == null ||
          filter["strategies"][strategy] == null)
        _reference.child("strategies").update({
          strategy: true,
        });
    });

    filter["strategies"]?.forEach((k, v) {
      if (k != "*" && !SettingsController.strategies.containsValue(k)) {
        _reference.child("strategies").update({
          k: null,
        });
      }
    });

    //update symbols filter
    if (filter == null ||
        filter["symbols"] == null ||
        filter["symbols"]["*"] == null) {
      _reference.child("symbols").update({
        "*": true,
      });
    }

    SettingsController.symbols.keys.forEach((symbol) {
      if (filter == null ||
          filter["symbols"] == null ||
          filter["symbols"][symbol] == null)
        _reference.child("symbols").update({
          symbol: true,
        });
    });

    filter["symbols"]?.forEach((k, v) {
      if (k != "*" && !SettingsController.symbols.containsKey(k)) {
        _reference.child("symbols").update({
          k: null,
        });
      }
    });
  }
}
