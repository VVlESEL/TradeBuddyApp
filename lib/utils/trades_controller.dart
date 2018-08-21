import 'dart:async';
import 'dart:collection';
import 'package:rxdart/rxdart.dart';
import 'package:trade_buddy/utils/trade_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/utils/auth.dart';

class TradesController {
  //get a reference to the trades db entry of the user
  static final DatabaseReference reference= FirebaseDatabase.instance
      .reference()
      .child("user/${Auth.user.uid}/trades");
  static final List<Trade> trades = List();
  static final _tradesSubject = BehaviorSubject<UnmodifiableListView<Trade>>();

  static Stream<List<Trade>> get tradesStream => _tradesSubject.stream;

  ///The function initializes the controller
  static Future<void> initialize() async {
    //add a listener for new child and check if it meets the filter criteria
    reference.onChildAdded.listen((event) {
      if(addTrade(Trade.fromJson(event.snapshot.key, event.snapshot.value))) {
        _tradesSubject.add(UnmodifiableListView(trades));
      }
    });

    reference.onChildRemoved.listen((event) {
      trades.removeWhere((trade) => trade.id == int.tryParse(event.snapshot.key) ?? 0);
      _tradesSubject.add(UnmodifiableListView(trades));
    });
  }

  ///The function updates all trades in the db that meet the filter criteria
  static Future<void> updateTrades() async {
    DataSnapshot dbTrades = await reference.once();
    if (dbTrades.value == null) return;

    trades.clear();
    dbTrades.value.forEach((key, value) {
      addTrade(Trade.fromJson(key, value));
    });

    _tradesSubject.add(UnmodifiableListView(trades));
  }

  ///The function adds a single trade that meets the filter criteria to the list
  static bool addTrade(Trade trade) {
    //check if the trade meets the filter criteria
    trades.add(trade);
    return true;
  }

  ///The function checks if a trade meets the filter criteria
  //bool checkTrade(Trade trade){ ... }
}