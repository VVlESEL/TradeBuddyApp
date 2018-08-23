import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trades_controller.dart';

class AnalyticsChart extends StatelessWidget {
  final bool animate;

  AnalyticsChart({this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createData(),
      animate: animate,
    );
  }

  static List<charts.Series<TimeSeriesTrade, DateTime>> _createData() {
    num equity = 0; //SettingsController.balance;

    final data = TradesController.trades.map((trade){
      equity += trade.profit;
      DateTime time = DateTime.tryParse(trade.opentime.replaceAll(".", "-"));
      return TimeSeriesTrade(time, equity);
    }).toList();

    return [
      charts.Series<TimeSeriesTrade, DateTime>(
        id: 'Trades',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesTrade trade, _) => trade.time,
        measureFn: (TimeSeriesTrade trade, _) => trade.equity,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesTrade {
  final DateTime time;
  final num equity;

  TimeSeriesTrade(this.time, this.equity);
}