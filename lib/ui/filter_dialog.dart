import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/filter_controller.dart';
import 'package:trade_buddy/utils/trades_controller.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  bool _isBuy = FilterController.filter["buy"];
  bool _isSell = FilterController.filter["sell"];
  Map _strategies = FilterController.filter["strategies"];
  Map _symbols = FilterController.filter["symbols"];

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TabBar(
        labelColor: Colors.blueAccent,
        controller: tabController,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.view_agenda)),
          Tab(icon: Icon(Icons.filter_none)),
          Tab(icon: Icon(Icons.build)),
        ],
      ),
      content: TabBarView(
        controller: tabController,
        children: <Widget>[
          getGeneral(),
          getSymbols(),
          getStrategies(),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Apply"),
          onPressed: () async {
            await FilterController.updateGeneral(buy: _isBuy, sell: _isSell);
            await FilterController.updateSymbols(_symbols);
            await FilterController.updateStrategies(_strategies);
            await FilterController.updateFilter();
            TradesController.initialize();
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

  Widget getGeneral() {
    print(_isBuy);
    print(_isSell);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            elevation: 1.0,
            color: _isBuy ? Theme.of(context).primaryColor : Colors.white,
            child: ListTile(
              title: Text("Buy Trades"),
              onTap: () => setState(() => _isBuy = !_isBuy),
            ),
          ),
          Card(
            elevation: 1.0,
            color: _isSell ? Theme.of(context).primaryColor : Colors.white,
            child: ListTile(
              title: Text("Sell Trades"),
              onTap: () => setState(() => _isSell = !_isSell),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSymbols() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            elevation: 1.0,
            color:
                _symbols["*"] ? Theme.of(context).primaryColor : Colors.white,
            child: ListTile(
              title: Text("*"),
              onTap: () {
                setState(() => _symbols["*"] = !_symbols["*"]);
              },
            ),
          )
        ]..addAll(_symbols?.keys?.map((symbol) {
              return symbol == "*"
                  ? Container(
                      width: 0.0,
                      height: 0.0,
                    )
                  : Card(
                      elevation: 1.0,
                      color: _symbols[symbol]
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      child: ListTile(
                        title: Text("$symbol"),
                        onTap: () {
                          setState(() => _symbols[symbol] = !_symbols[symbol]);
                        },
                      ),
                    );
            })?.toList() ??
            [Text("No Symbols found...")]),
      ),
    );
  }

  Widget getStrategies() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            elevation: 1.0,
            color: _strategies["*"]
                ? Theme.of(context).primaryColor
                : Colors.white,
            child: ListTile(
              title: Text("*"),
              onTap: () {
                setState(() => _strategies["*"] = !_strategies["*"]);
              },
            ),
          )
        ]..addAll(
            _strategies?.keys?.map((strategy) {
                  return strategy == "*"
                      ? Container(
                          width: 0.0,
                          height: 0.0,
                        )
                      : Card(
                          elevation: 1.0,
                          color: _strategies[strategy]
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          child: ListTile(
                            title: Text("$strategy"),
                            onTap: () {
                              setState(() => _strategies[strategy] =
                                  !_strategies[strategy]);
                            },
                          ),
                        );
                })?.toList() ??
                [Text("No Strategies found...")],
          ),
      ),
    );
  }
}
