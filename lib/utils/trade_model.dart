class Trade {
  num _id;
  String _symbol;
  num _lots;
  String _type;
  num _openprice;
  String _opentime;
  num _closeprice;
  String _closetime;
  num _commission;
  num _swap;
  num _profit;
  num _takeprofit;
  num _stoploss;
  String _commentary;

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
  String toString() {
    return 'Trade{_id: $_id, _symbol: $_symbol, _lots: $_lots, _type: $_type, _openprice: $_openprice, _opentime: $_opentime, _closeprice: $_closeprice, _closetime: $_closetime, _commission: $_commission, _swap: $_swap, _profit: $_profit, _takeprofit: $_takeprofit, _stoploss: $_stoploss, _commentary: $_commentary}';
  }

  @override
  int get hashCode => super.hashCode;

  String get commentary => _commentary;

  set commentary(String value) => _commentary = value;

  num get stoploss => _stoploss;

  set stoploss(num value) => _stoploss = value;

  num get takeprofit => _takeprofit;

  set takeprofit(num value) => _takeprofit = value;

  num get profit => _profit;

  set profit(num value) => _profit = value;

  num get swap => _swap;

  set swap(num value) => _swap = value;

  num get commission => _commission;

  set commission(num value) => _commission = value;

  String get closetime => _closetime;

  set closetime(String value) => _closetime = value;

  num get closeprice => _closeprice;

  set closeprice(num value) => _closeprice = value;

  String get opentime => _opentime;

  set opentime(String value) => _opentime = value;

  num get openprice => _openprice;

  set openprice(num value) => _openprice = value;

  String get type => _type;

  set type(String value) => _type = value;

  num get lots => _lots;

  set lots(num value) => _lots = value;

  String get symbol => _symbol;

  set symbol(String value) => _symbol = value;

  num get id => _id;

  set id(num value) => _id = value;
}
