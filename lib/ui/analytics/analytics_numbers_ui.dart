import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/analytics_controller.dart';

class AnalyticsNumbers extends StatefulWidget {
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<AnalyticsNumbers> {
  final double _fontSize = 20.0;
  final Color _colorLoss = Colors.redAccent;
  final Color _colorWin = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    AnalyticsController.calcNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Net Profit",
              style: TextStyle(
                fontSize: _fontSize,
              )
            ),
            Text(
              "${AnalyticsController.netProfit.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: AnalyticsController.netProfit > 0 ? _colorWin : _colorLoss,
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Profit Factor",
              style: TextStyle(
                fontSize: _fontSize,
              ),
            ),
            Text(
              "${AnalyticsController.profitFactor.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: AnalyticsController.profitFactor > 1 ? _colorWin : _colorLoss
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Trades",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.tradesAmount}",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
          ],
        ),
        Padding(padding: const EdgeInsets.only(top: 16.0),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Gross Profit",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.grossProfit.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorWin
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Gross Loss",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.grossLoss.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorLoss
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Expected Profit",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.expectedProfit.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: AnalyticsController.expectedProfit > 0 ? _colorWin : _colorLoss
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Max Drawdown",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.maxDrawdownMoney.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorLoss
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Max Drawdown %",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.maxDrawdownPercent.toStringAsFixed(2)}%",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorLoss
                )
            ),
          ],
        ),
        Padding(padding: const EdgeInsets.only(top: 16.0),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Sell-Trades (won)",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.sellTradesAmount} (${AnalyticsController.sellTradesPercent.toStringAsFixed(2)}%)",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Buy-Trades (won)",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.buyTradesAmount} (${AnalyticsController.buyTradesPercent.toStringAsFixed(2)}%)",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
          ],
        ),
        Padding(padding: const EdgeInsets.only(top: 16.0),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Positive Trades (%)",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.wonTradesAmount} (${AnalyticsController.wonTradesPercent.toStringAsFixed(2)}%)",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorWin,
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Negative Trades (%)",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.lostTradesAmount} (${AnalyticsController.lostTradesPercent.toStringAsFixed(2)}%)",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorLoss,
                )
            ),
          ],
        ),
        Padding(padding: const EdgeInsets.only(top: 16.0),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Biggest Profit",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.biggestProfit.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorWin,
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Average Profit",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.averageProfit.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorWin,
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Max Wins in a Row",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.maxWinRowAmount}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorWin,
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Max Profit in a Row",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.maxWinRowMoney.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorWin,
                )
            ),
          ],
        ),
        Padding(padding: const EdgeInsets.only(top: 16.0),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Biggest Loss",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.biggestLoss.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorLoss,
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Average Loss",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.averageLoss.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorLoss,
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Max Losses in a Row",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.maxLossRowAmount}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorLoss,
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Max Loss in a Row",
                style: TextStyle(
                  fontSize: _fontSize,
                )
            ),
            Text(
              "${AnalyticsController.maxLossRowMoney.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _colorLoss,
                )
            ),
          ],
        ),
      ],
    );
  }
}
