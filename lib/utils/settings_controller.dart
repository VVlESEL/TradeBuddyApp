import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'dart:async';

class SettingsController {
  //get a reference to the trades db entry of the user
  static final DatabaseReference reference = FirebaseDatabase.instance
      .reference()
      .child("user/${Auth.user.uid}/settings");

  static num _balance = 0.0;
  static String _currentAccount;
  static Map _accounts;

  ///The function initializes the controller
  static Future<void> initialize() async {
    //get initial settings
    var snapshot = await reference.once();
    if (snapshot.value == null) return;
    balance = snapshot.value["balance"];
    accounts = snapshot.value["accounts"];
    currentAccount = snapshot.value["current_account"];

    if (currentAccount == null && accounts != null) {
      currentAccount = accounts.keys.first;
      reference.update({
        "current_account": currentAccount,
      });
    }

    print(
        "AnalyticsController.initialize(): balance = $balance, accounts = $accounts, currentAccount = $currentAccount");

    //add a listener for new child and check if it meets the filter criteria
    reference.onChildChanged.listen((event) {
      switch(event.snapshot.key){
        case "accounts":
          accounts = event.snapshot.value;
          print("AnalyticsController: accounts = $accounts");
          if (currentAccount == null && accounts != null) {
            currentAccount = accounts.keys.first;
            print("AnalyticsController: currentAccount = $currentAccount");
            reference.update({
              "current_account": currentAccount,
            });
          }
          break;
      }
    });
  }

  static Map get accounts => _accounts;
  static set accounts(Map value) {
    _accounts = value;
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
    reference.update({
      "balance": balance,
    });
  }
}
