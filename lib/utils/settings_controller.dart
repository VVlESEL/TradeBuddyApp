import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'dart:async';

import 'package:trade_buddy/utils/trades_controller.dart';

class SettingsController {
  //get a reference to the trades db entry of the user
  static DatabaseReference reference;

  static num _balance = 10000;
  static String _currentAccount;
  static Map accounts;

  ///The function initializes the controller
  static Future<void> initialize() async {
    reference = FirebaseDatabase.instance
        .reference()
        .child("user/${Auth.user.uid}/settings");

    //get initial settings
    var snapshot = await reference.once();

    if (snapshot.value != null && snapshot.value["accounts"] != "initialized") {
      //get all accounts
      accounts = snapshot.value["accounts"];

      //get current account
      currentAccount = snapshot.value["current_account"];
      if (currentAccount == null && accounts != null) {
        currentAccount = accounts.keys.first;
        reference.update({
          "current_account": currentAccount,
        });
      }

      //get balance for the current account
      try {
        _balance = snapshot.value["accounts"][currentAccount]["balance"];
      } catch (error) {
        _balance = 10000;
      }

      print("AnalyticsController.initialize(): balance = $balance, accounts = "
          "$accounts, currentAccount = $currentAccount");
    }

    //add a listener for new child and check if it meets the filter criteria
    reference.onChildChanged.listen((event) async {
      switch (event.snapshot.key) {
        case "accounts":
          accounts = event.snapshot.value;
          if (currentAccount == null && accounts != null) {
            currentAccount = accounts.keys.first;
            reference.update({
              "current_account": currentAccount,
            });
            try {
              _balance = snapshot.value["accounts"][currentAccount]["balance"];
            } catch (error) {
              _balance = 10000;
            }
            TradesController.initialize();
          }
          print(
              "AnalysticsController onChildChanged.listen: balance = $balance, "
              "accounts = $accounts, currentAccount = $currentAccount");
          break;
        case "current_account":
          var snapshot =
              await reference.child("accounts/$currentAccount").once();
          if (snapshot.value == null) return;
          try {
            _balance = snapshot.value["balance"];
          } catch (error) {
            _balance = 10000;
          }
          print(
              "AnalysticsController onChildChanged.listen: balance = $balance, "
                  "accounts = $accounts, currentAccount = $currentAccount");
          break;
      }
    });
  }

  static String get currentAccount => _currentAccount;

  static set currentAccount(String value) {
    _currentAccount = value;
    reference.update({
      "current_account": currentAccount,
    });
  }

  static num get balance => _balance;

  static set balance(num value) {
    _balance = value;
    reference.child("accounts/$currentAccount").update({
      "balance": balance,
    });
  }
}
