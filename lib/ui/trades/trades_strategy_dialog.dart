import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trade_model.dart';

class StrategyDialog extends StatelessWidget {
  final Trade trade;

  StrategyDialog(this.trade);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Strategies"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: SettingsController.strategies.length > 1
              ? SettingsController.strategies?.keys?.map((strategy) {
                  return strategy == "*"
                      ? Container(
                          width: 0.0,
                          height: 0.0,
                        )
                      : Card(
                          elevation: 1.0,
                          color: SettingsController.strategies[strategy]
                                      ["abbreviation"] ==
                                  trade.strategy
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          child: ListTile(
                            title: Text("$strategy"),
                            onTap: () {
                              trade.setStrategy(SettingsController
                                  .strategies[strategy]["abbreviation"]);
                              Navigator.pop(context);
                            },
                          ),
                        );
                })?.toList()
              : [Text("No Strategies found...")],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Remove Strategy"),
          onPressed: () {
            trade.setStrategy(null);
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
