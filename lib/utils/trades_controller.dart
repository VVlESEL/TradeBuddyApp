import 'dart:async';
import 'dart:collection';
import 'package:rxdart/rxdart.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trade_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/utils/auth.dart';

///static class that holds all the trades
class TradesController {
  static DatabaseReference reference;
  static final List<Trade> trades = List();
  static final _tradesSubject = BehaviorSubject<UnmodifiableListView<Trade>>();
  static final _isLoadingSubject = BehaviorSubject<bool>();

  ///streams the current list of trades
  static Stream<List<Trade>> get tradesStream => _tradesSubject.stream;

  ///streams if the controller is currently loading or deleting trades
  static Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  ///The function initializes the controller
  static Future<void> initialize() async {
    var currentAccount = SettingsController.currentAccount;
    if (currentAccount == null) return;

    //get strategies for the filter criteria
    var strategiesList = [];
    SettingsController.strategies.forEach((k, v) {
      if (v["filter"]) strategiesList.add(v["abbreviation"] ?? k);
    });

    //get symbols for the filter criteria
    var symbolsList = [];
    SettingsController.symbols.forEach((k, v) {
      if (v["filter"]) symbolsList.add(k);
    });

    //get a reference to the db
    reference = FirebaseDatabase.instance
        .reference()
        .child("user/${Auth.user.uid}/accounts/$currentAccount/trades");

    //reset trades list
    trades.clear();

    //add a listener for new child and check if it meets the filter criteria
    reference.orderByChild("closetime").onChildAdded.listen((event) {
      _isLoadingSubject.add(true);
      if (addTrade(Trade.fromJson(event.snapshot.key, event.snapshot.value),
          symbolsList, strategiesList)) {
        trades.sort();
        _tradesSubject.add(UnmodifiableListView(trades.reversed));
      }
      _tradesSubject.add(UnmodifiableListView(trades.reversed));
      _isLoadingSubject.add(false);
    });

    reference.onChildRemoved.listen((event) {
      _isLoadingSubject.add(true);
      trades.removeWhere(
          (trade) => trade.id == int.tryParse(event.snapshot.key) ?? 0);
      _tradesSubject.add(UnmodifiableListView(trades.reversed));
      _isLoadingSubject.add(false);
    });
  }

  ///The function adds a single trade that meets the filter criteria to the list
  static bool addTrade(Trade trade, List symbolsList, List strategiesList) {
    //check general filter
    if (SettingsController.generalFilter != null) {
      if (!(SettingsController.generalFilter["sell"] ?? false) &&
          trade.type == "sell") return false;
      if (!(SettingsController.generalFilter["buy"] ?? false) &&
          trade.type == "buy") return false;
    }

    //check symbols filter
    if (!symbolsList.contains("*") && !symbolsList.contains(trade.symbol))
      return false;

    //check strategies filter
    if (!strategiesList.contains("*") && !strategiesList.contains(trade.strategy))
      return false;

    //add trade to the list
    if (!trades.contains(trade)) trades.add(trade);
    return true;
  }
}

/* not in use because it destoys the order of the trades when the closetime is equal
  ///The function updates all trades in the db
  static Future<void> updateTrades() async {
    _isLoadingSubject.add(true);
    DataSnapshot dbTrades = await reference.orderByChild("closetime").once();
    if (dbTrades.value == null) {
      _isLoadingSubject.add(false);
      return;
    }

    trades.clear();
    dbTrades.value.forEach((key, value) {
      addTrade(Trade.fromJson(key, value));
    });
    trades.sort();
    _tradesSubject.add(UnmodifiableListView(trades.reversed));
    _isLoadingSubject.add(false);
  }
*/