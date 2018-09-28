import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/utils/settings_controller.dart';

class Trade implements Comparable {
  num id;
  String symbol;
  num lots;
  String type;
  num openprice;
  String opentime;
  num closeprice;
  String closetime;
  num commission;
  num swap;
  num profit;
  num takeprofit;
  num stoploss;
  String commentary;

  String strategy;
  String screenshotPath;

  DatabaseReference reference;

  Trade.fromJson(String id, Map data) {
    this.id = int.tryParse(id) ?? 0;
    this.symbol = data["symbol"];
    this.lots = data["lots"];
    this.type = data["type"];
    this.openprice = data["openprice"];
    this.opentime = data["opentime"];
    this.closeprice = data["closeprice"];
    this.closetime = data["closetime"];
    this.commission = data["commission"];
    this.swap = data["swap"];
    this.profit = data["profit"];
    this.takeprofit = data["takeprofit"];
    this.stoploss = data["stoploss"];
    this.commentary = data["commentary"];
    this.strategy = data["strategy"] ?? null;
    this.screenshotPath = data["screenshot_path"] ?? null;

    this.reference = FirebaseDatabase.instance
        .reference()
        .child("user/${Auth.user.uid}/accounts/${SettingsController.currentAccount}/trades/$id");
  }

  @override
  bool operator ==(other) {
    return this.id == (other.id);
  }

  @override
  int compareTo(other) {
    Trade temp = other;
    return this.closetime.compareTo(temp.closetime);
  }

  @override
  String toString() {
    return 'Trade{id: $id, symbol: $symbol, lots: $lots, type: $type, '
        'openprice: $openprice, opentime: $opentime, closeprice: $closeprice, '
        'closetime: $closetime, commission: $commission, swap: $swap, '
        'profit: $profit, takeprofit: $takeprofit, stoploss: $stoploss, '
        'commentary: $commentary, strategy: $strategy, screenshotPath: $screenshotPath}';
  }

  @override
  int get hashCode => super.hashCode;

  Future<void> setScreenshotPath(String value) async {
    print("screenshotPath = $value");
    if(screenshotPath == value) return;
    screenshotPath = value;
    await reference.update({
      "screenshot_path": value,
    });
  }

  Future<void> setCommentary(String value) async {
    print("commentary = $value");
    if(commentary == value) return;
    commentary = value;
    await reference.update({
      "commentary": value,
    });
  }

  Future<void> setStrategy(String value) async {
    print("strategy = $value");
    if(strategy == value) return;
    strategy = value;
    await reference.update({
      "strategy": value,
    });
  }
}
