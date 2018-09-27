import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trade_buddy/utils/auth.dart';
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
  static Stream<List> get accountsStream => _accountsSubject.stream;
  static final _accountsSubject = BehaviorSubject<List>();
  static List _accounts = [];

  ///streams the general filter of the current account
  static Stream<Map> get generalFilterStream => _generalFilterSubject.stream;
  static final _generalFilterSubject = BehaviorSubject<Map>();
  static Map _generalFilter;

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
    _reference =
        FirebaseDatabase.instance.reference().child("user/${Auth.user.uid}");

    //get current account
    await setCurrentAccount(
        (await _reference.child("settings/current_account").once()).value);

    //add a listener for new child
    _reference.child("accounts").onChildAdded
        .listen((event) async {
      accounts.add(event.snapshot.key);
      if (currentAccount == null && accounts != null) {
        await setCurrentAccount(accounts.first);
      }
    });
  }

  static List get accounts => _accounts;

  static set accounts(List value) {
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
    _reference.child("settings").update({
      "current_account": value,
    });
    await fetchCurrentAccountData();
  }

  static Future<void> fetchCurrentAccountData() async {
    var snapshot = await _reference.child("accounts/$currentAccount").once();
    if (snapshot.value == null) return;
    balance = snapshot.value["balance"];
    generalFilter = snapshot.value["general_filter"];
    strategies = snapshot.value["strategies"];
    symbols = snapshot.value["symbols"];
//    await FilterController.initialize();
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

  static Map get generalFilter => _generalFilter;

  static set generalFilter(Map value) {
    print("generalFilter = $value");
    if(generalFilter == value && value != null) return;
    _generalFilter = value ?? Map();
    _generalFilterSubject.add(_generalFilter);
  }

  static updateGeneralFilter(Map newGeneralFilter) async {
    print("updateGeneralFilter = $newGeneralFilter");
    generalFilter = newGeneralFilter;
    generalFilter.forEach((k,v) async {
      await _reference.child("accounts/$currentAccount/general_filter").update({
        k: v,
      });
    });
  }

  static Map get strategies => _strategies;

  static set strategies(Map value) {
    print("strategies = $value");
    if (strategies == value && value != null) return;
    _strategies = value ?? Map();
    _strategiesSubject.add(_strategies);
  }

  static addStrategy(String name, String abbreviation, bool filter) {
    print("addStrategy = $name");
    var value = {
      name: {
        "abbreviation": abbreviation,
        "filter": filter,
      }
    };
    _strategies.addAll(value);
    _strategiesSubject.add(_strategies);
    _reference.child("accounts/$currentAccount/strategies").update(value);
  }

  static updateStrategies(Map newStrategies) async {
    print("updateStrategies = $newStrategies");
    strategies = newStrategies;
    strategies.forEach((k,v) async {
      await _reference.child("accounts/$currentAccount/strategies").update({
        k: v,
      });
    });
  }

  static removeStrategy(String value) {
    print("removeStrategie = $value");
    _strategies.remove(value);
    _strategiesSubject.add(_strategies);
    _reference.child("accounts/$currentAccount/strategies/$value").remove();
  }

  static Map get symbols => _symbols;

  static set symbols(Map value) {
    print("symbols = $value");
    if (symbols == value && value != null) return;
    _symbols = value ?? Map();
    _symbolsSubject.add(_symbols);
  }

  static addSymbol(String name, bool filter) {
    print("addSymbol = $name");
    var value = {
      name: {
        "filter": filter,
      }
    };
    _symbols.addAll(value);
    _symbolsSubject.add(_symbols);
    _reference.child("accounts/$currentAccount/symbols").update(value);
  }

  static updateSymbols(Map newSymbols) async {
    print("updateSymbols = $newSymbols");
    symbols = newSymbols;
    symbols.forEach((k,v) async {
      await _reference.child("accounts/$currentAccount/symbols").update({
        k: v,
      });
    });
  }

  static removeSymbol(String value) {
    print("removeSymbol = $value");
    _symbols.remove(value);
    _symbolsSubject.add(_symbols);
    _reference.child("accounts/$currentAccount/symbols/$value").remove();
  }
}
