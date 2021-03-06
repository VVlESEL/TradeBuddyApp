import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:trade_buddy/ui/trades/trades_commentary_dialog.dart';
import 'package:trade_buddy/ui/trades/trades_screenshot_dialog.dart';
import 'package:trade_buddy/utils/trade_model.dart';
import 'package:trade_buddy/utils/trades_controller.dart';
import 'package:trade_buddy/ui/trades/trades_strategy_dialog.dart';

class Trades extends StatefulWidget {
  @override
  _TradesState createState() => _TradesState();
}

class _TradesState extends State<Trades> {
  @override
  Widget build(BuildContext context) {
    return /*Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child:*/ StreamBuilder<UnmodifiableListView<Trade>>(
        stream: TradesController.tradesStream,
        initialData: UnmodifiableListView<Trade>([]),
        builder: (context, snapshot) => ListView(
              children: snapshot.data
                  .map((trade) => TradeTile(
                        trade: trade,
                      ))
                  .toList(),
            ),
//      ),
    );
  }
}

class TradeTile extends StatefulWidget {
  final Trade trade;

  TradeTile({this.trade});

  @override
  _TradeTileState createState() => _TradeTileState();
}

class _TradeTileState extends State<TradeTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    widget.trade.symbol,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " ${widget.trade.type} ${widget.trade.lots}",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: widget.trade.type.toString() == "buy"
                          ? Colors.blueAccent
                          : Colors.redAccent,
                    ),
                  ),
                ],
              ),
              Text("${widget.trade.openprice} => ${widget.trade.closeprice}"),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(widget.trade.closetime),
              Text(
                "${widget.trade.profit}",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: widget.trade.profit > 0
                      ? Colors.blueAccent
                      : Colors.redAccent,
                ),
              ),
            ],
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${widget.trade.opentime}, ${widget.trade.commentary}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("SL:"),
                          Text("TP:"),
                          Text("ID:"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("${widget.trade.stoploss}"),
                          Text("${widget.trade.takeprofit}"),
                          Text("${widget.trade.id}"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Swap:"),
                          Text("Commission:"),
                          Text("Strategy:"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("${widget.trade.swap}"),
                          Text("${widget.trade.commission}"),
                          Text("${widget.trade.strategy ?? ""}"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    child: Icon(Icons.camera_alt),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Screenshot(widget.trade)))),
                FlatButton(
                  child: Icon(Icons.mode_edit),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CommentaryDialog(widget.trade));
                    this.setState(() {});
                  },
                ),
                FlatButton(
                  child: Icon(Icons.build),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            StrategyDialog(widget.trade));
                    this.setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
