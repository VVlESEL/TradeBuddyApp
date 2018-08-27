import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'dart:async';

import 'package:trade_buddy/utils/trades_controller.dart';

class SettingsController {
  //get a reference to the trades db entry of the user
  static DatabaseReference reference;

  ///streams the current balance
  static Stream<num> get balanceStream => _balanceSubject.stream;
  static final _balanceSubject = BehaviorSubject<num>();
  static num _balance;

  ///streams the current balance
  static Stream<String> get currentAccountStream =>
      _currentAccountSubject.stream;
  static final _currentAccountSubject = BehaviorSubject<String>();
  static String _currentAccount;

  ///streams the current balance
  static Stream<Map> get accountsStream => _accountsSubject.stream;
  static final _accountsSubject = BehaviorSubject<Map>();
  static Map _accounts;

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
      if (currentAccount == null) {
        currentAccount = accounts.keys.first;
        reference.update({
          "current_account": currentAccount,
        });
      }

      //get balance for the current account
      try {
        balance = snapshot.value["accounts"][currentAccount]["balance"];
      } catch (error) {
        balance = 10000;
      }

      print("AnalyticsController.initialize(): balance = $balance, "
          "accounts = $accounts, currentAccount = $currentAccount");
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
              balance = snapshot.value["accounts"][currentAccount]["balance"];
            } catch (error) {
              balance = 10000;
            }
            TradesController.initialize();
          }
          print("AnalyticsController.initialize(): balance = $balanceStream, "
              "accounts = $accounts, currentAccount = $currentAccount");
          break;
        case "current_account":
          var snapshot =
              await reference.child("accounts/$currentAccount").once();
          if (snapshot.value == null) return;
          try {
            balance = snapshot.value["accounts"][currentAccount]["balance"];
          } catch (error) {
            balance = 10000;
          }
          TradesController.initialize();
          print("AnalyticsController.initialize(): balance = $balanceStream, "
              "accounts = $accounts, currentAccount = $currentAccount");
          break;
      }
    });
  }

  static Map get accounts => _accounts;
  static set accounts(Map value) {
    print("accounts = $value");
    _accounts = value;
    _accountsSubject.add(value);
  }

  static String get currentAccount => _currentAccount;
  static set currentAccount(String value) {
    print("currentAccount = $value");
    _currentAccount = value;
    _currentAccountSubject.add(value);
    reference.update({
      "current_account": value,
    });
  }

  static num get balance => _balance;
  static set balance(num value) {
    print("balance = $value");
    _balance = value;
    _balanceSubject.add(value);
    reference.child("accounts/${currentAccount}").update({
      "balance": value,
    });
  }
}
