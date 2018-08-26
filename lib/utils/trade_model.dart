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
    return 'Trade{_id: $id, _symbol: $symbol, _lots: $lots, _type: $type, _openprice: $openprice, _opentime: $opentime, _closeprice: $closeprice, _closetime: $closetime, _commission: $commission, _swap: $swap, _profit: $profit, _takeprofit: $takeprofit, _stoploss: $stoploss, _commentary: $commentary}';
  }

  @override
  int get hashCode => super.hashCode;
}
