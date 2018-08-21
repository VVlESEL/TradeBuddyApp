class Trade {
  int _id;
  String _symbol;
  double _lots;
  String _type;
  double _openprice;
  String _opentime;
  double _closeprice;
  String _closetime;
  double _commission;
  double _swap;
  double _profit;
  double _takeprofit;
  double _stoploss;
  String _commentary;

  Trade.fromJson(String id, Map data) {
    this.id = int.tryParse(id) ?? 0;
    this.symbol = data["symbol"];
    this.lots = double.parse(data["lots"]);
    this.type = data["type"];
    this.openprice = double.tryParse(data["openprice"]) ??
        int.tryParse(data["openprice"]) ??
        0.0;
    this.opentime = data["opentime"];
    this.closeprice = double.tryParse(data["closeprice"]) ??
        int.tryParse(data["closeprice"]) ??
        0.0;
    this.closetime = data["closetime"];
    this.commission = double.tryParse(data["commission"]) ?? 0.0;
    this.swap = double.tryParse(data["swap"]) ?? 0.0;
    this.profit = double.tryParse(data["profit"]) ?? 0.0;
    this.takeprofit = double.tryParse(data["takeprofit"]) ??
        int.tryParse(data["takeprofit"]) ??
        0.0;
    this.stoploss = double.tryParse(data["stoploss"]) ??
        int.tryParse(data["stoploss"]) ??
        0.0;
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

  double get stoploss => _stoploss;

  set stoploss(double value) => _stoploss = value;

  double get takeprofit => _takeprofit;

  set takeprofit(double value) => _takeprofit = value;

  double get profit => _profit;

  set profit(double value) => _profit = value;

  double get swap => _swap;

  set swap(double value) => _swap = value;

  double get commission => _commission;

  set commission(double value) => _commission = value;

  String get closetime => _closetime;

  set closetime(String value) => _closetime = value;

  double get closeprice => _closeprice;

  set closeprice(double value) => _closeprice = value;

  String get opentime => _opentime;

  set opentime(String value) => _opentime = value;

  double get openprice => _openprice;

  set openprice(double value) => _openprice = value;

  String get type => _type;

  set type(String value) => _type = value;

  double get lots => _lots;

  set lots(double value) => _lots = value;

  String get symbol => _symbol;

  set symbol(String value) => _symbol = value;

  int get id => _id;

  set id(int value) => _id = value;
}
