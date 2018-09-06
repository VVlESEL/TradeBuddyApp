import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/utils/filter_controller.dart';
import 'dart:async';

import 'package:trade_buddy/utils/trades_controller.dart';

///static class that holds all necessary settings
class SettingsController {
  //get a reference to the trades db entry of the user
  static DatabaseReference _reference;

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

  ///streams the strategies of the current account
  static Stream<Map> get strategiesStream => _strategiesSubject.stream;
  static final _strategiesSubject = BehaviorSubject<Map>();
  static Map _strategies;

  ///streams the symbols of the current account
  static Stream<Map> get symbolsStream => _symbolsSubject.stream;
  static final _symbolsSubject = BehaviorSubject<Map>();
  static Map _symbols;

  ///The function initializes the controller
  static Future<void> initialize() async {
    _reference = FirebaseDatabase.instance
        .reference()
        .child("user/${Auth.user.uid}/settings");

    //add a listener for new child and child changes
    _reference.onChildAdded.listen((event) => fetchSettingsFromDb(event));
    _reference.onChildChanged.listen((event) => fetchSettingsFromDb(event));
  }

  static fetchSettingsFromDb(Event event) async {
    switch (event.snapshot.key) {
      case "accounts":
        accounts = event.snapshot.value;
        await setCurrentAccount(
            (await _reference.child("current_account").once()).value);
        if (currentAccount == null && accounts != null) {
          await setCurrentAccount(accounts.keys.first);
        }
        break;
    }
  }

  static Map get accounts => _accounts;

  static set accounts(Map value) {
    print("accounts = $value");
    if (accounts == value) return;
    _accounts = value;
    _accountsSubject.add(value);
  }

  static String get currentAccount => _currentAccount;

  static setCurrentAccount(String value) async {
    print("currentAccount = $value");
    if (currentAccount == value) return;
    _currentAccount = value;
    _currentAccountSubject.add(value);
    await _reference.update({
      "current_account": value,
    });
    await fetchCurrentAccountData();
  }

  static Future<void> fetchCurrentAccountData() async {
    var snapshot = await _reference.child("accounts/$currentAccount").once();
    if (snapshot.value == null) return;
    balance = snapshot.value["balance"];
    strategies = snapshot.value["strategies"];
    symbols = snapshot.value["symbols"];
    await FilterController.initialize();
    await TradesController.initialize();
  }

  static num get balance => _balance;

  static set balance(num value) {
    print("balance = $value");
    if (balance == value) return;
    _balance = value;
    _balanceSubject.add(value);
    _reference.child("accounts/$currentAccount").update({
      "balance": value,
    });
  }

  static Map get strategies => _strategies;

  static set strategies(Map value) {
    print("strategies = $value");
    if (strategies == value && value != null) return;
    _strategies = value ?? Map();
    _strategiesSubject.add(_strategies);
  }

  static addStrategiy(Map<String, dynamic> value) {
    print("addStrategie = $value");
    _strategies.addAll(value);
    _strategiesSubject.add(_strategies);
    _reference.child("accounts/$currentAccount/strategies").update(value);
    FilterController.initialize();
  }

  static removeStrategiy(String value) {
    print("removeStrategie = $value");
    _strategies.remove(value);
    _strategiesSubject.add(_strategies);
    _reference.child("accounts/$currentAccount/strategies/$value").remove();
    FilterController.initialize();
  }

  static Map get symbols => _symbols;

  static set symbols(Map value) {
    print("symbols = $value");
    if (symbols == value && value != null) return;
    _symbols = value ?? Map();
    _symbolsSubject.add(_symbols);
  }

  static addSymbol(Map<String, dynamic> value) {
    print("addSymbol = $value");
    _symbols.addAll(value);
    _symbolsSubject.add(_symbols);
    _reference.child("accounts/$currentAccount/symbols").update(value);
    FilterController.initialize();
  }

  static removeSymbol(String value) {
    print("removeSymbol = $value");
    _symbols.remove(value);
    _symbolsSubject.add(_symbols);
    _reference.child("accounts/$currentAccount/symbols/$value").remove();
    FilterController.initialize();
  }
}
