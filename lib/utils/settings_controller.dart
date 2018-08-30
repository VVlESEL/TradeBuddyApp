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

  ///streams the current account
  static Stream<String> get currentAccountStream =>
      _currentAccountSubject.stream;
  static final _currentAccountSubject = BehaviorSubject<String>();
  static String _currentAccount;

  ///streams the accounts
  static Stream<Map> get accountsStream => _accountsSubject.stream;
  static final _accountsSubject = BehaviorSubject<Map>();
  static Map _accounts;

  ///streams the accounts
  static Stream<Map> get strategiesStream => _strategiesSubject.stream;
  static final _strategiesSubject = BehaviorSubject<Map>();
  static Map _strategies;

  ///The function initializes the controller
  static Future<void> initialize() async {
    reference = FirebaseDatabase.instance
        .reference()
        .child("user/${Auth.user.uid}/settings");

    //get initial settings
    var snapshot = await reference.once();
    if (snapshot.value != null &&
        snapshot.value["accounts"] != null &&
        snapshot.value["accounts"] != "initialized") {
      //get all accounts
      accounts = snapshot.value["accounts"];

      //get current account
      currentAccount = snapshot.value["current_account"];
      if (currentAccount == null) {
        currentAccount = accounts.keys.first;
      }

      //get balance and strategies for the current account
      if (currentAccount != null) {
        balance = snapshot.value["accounts"][currentAccount]["balance"];
        strategies = snapshot.value["accounts"][currentAccount]["strategies"];
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
            balance = snapshot.value["accounts"][currentAccount]["balance"];
            TradesController.initialize();
          }
          print("AnalyticsController.initialize(): balance = $balance, "
              "accounts = $accounts, currentAccount = $currentAccount");
          break;
        case "current_account":
          var snapshot =
              await reference.child("accounts/$currentAccount").once();
          if (snapshot.value == null) return;
          balance = snapshot.value["balance"];
          strategies = snapshot.value["strategies"];
          TradesController.initialize();
          print("AnalyticsController.initialize(): balance = $balance, "
              "accounts = $accounts, currentAccount = $currentAccount");
          break;
      }
    });
  }

  static Map get accounts => _accounts;

  static set accounts(Map value) {
    print("accounts = $value");
    if(accounts == value) return;
    _accounts = value;
    _accountsSubject.add(value);
  }

  static Map get strategies => _strategies;

  static set strategies(Map value) {
    print("strategies = $value");
    if(strategies == value && value != null) return;
    _strategies = value ?? Map();
    _strategiesSubject.add(_strategies);
  }

  static addStrategiy(Map<String, dynamic> value) {
    print("addStrategie = $value");
    _strategies.addAll(value);
    _strategiesSubject.add(_strategies);
    reference.child("accounts/$currentAccount/strategies").update(value);
  }

  static removeStrategiy(String value) {
    print("removeStrategie = $value");
    _strategies.remove(value);
    _strategiesSubject.add(_strategies);
    reference.child("accounts/$currentAccount/strategies/$value").remove();
  }

  static String get currentAccount => _currentAccount;

  static set currentAccount(String value) {
    print("currentAccount = $value");
    if(currentAccount == value) return;
    _currentAccount = value;
    _currentAccountSubject.add(value);
    reference.update({
      "current_account": value,
    });
  }

  static num get balance => _balance;

  static set balance(num value) {
    print("balance = $value");
    if(balance == value) return;
    _balance = value;
    _balanceSubject.add(value);
    reference.child("accounts/$currentAccount").update({
      "balance": value,
    });
  }
}
