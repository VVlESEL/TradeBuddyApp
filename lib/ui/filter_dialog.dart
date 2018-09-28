import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trades_controller.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  Map _generalFilter = SettingsController.generalFilter;
  Map _strategies = SettingsController.strategies;
  Map _symbols = SettingsController.symbols;

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
      content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: TabBarView(
          controller: tabController,
          children: <Widget>[
            getGeneral(),
            getSymbols(),
            getStrategies(),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Apply"),
          onPressed: () async {
            await SettingsController.updateGeneralFilter(_generalFilter);
            await SettingsController.updateSymbols(_symbols);
            await SettingsController.updateStrategies(_strategies);
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            elevation: 1.0,
            color: _generalFilter["buy"] ? Theme.of(context).primaryColor : Colors.white,
            child: ListTile(
              title: Text("Buy Trades"),
              onTap: () => setState(() => _generalFilter["buy"] = !_generalFilter["buy"]),
            ),
          ),
          Card(
            elevation: 1.0,
            color: _generalFilter["sell"] ? Theme.of(context).primaryColor : Colors.white,
            child: ListTile(
              title: Text("Sell Trades"),
              onTap: () => setState(() => _generalFilter["sell"] = !_generalFilter["sell"]),
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
                _symbols["*"]["filter"] ? Theme.of(context).primaryColor : Colors.white,
            child: ListTile(
              title: Text("*"),
              onTap: () {
                setState(() => _symbols["*"]["filter"] = !_symbols["*"]["filter"]);
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
                      color: _symbols[symbol]["filter"]
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      child: ListTile(
                        title: Text("$symbol"),
                        onTap: () {
                          setState(() => _symbols[symbol]["filter"] = !_symbols[symbol]["filter"]);
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
            color: _strategies["*"]["filter"]
                ? Theme.of(context).primaryColor
                : Colors.white,
            child: ListTile(
              title: Text("*"),
              onTap: () {
                setState(() => _strategies["*"]["filter"] = !_strategies["*"]["filter"]);
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
                          color: _strategies[strategy]["filter"]
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          child: ListTile(
                            title: Text("$strategy"),
                            onTap: () {
                              setState(() => _strategies[strategy]["filter"] =
                                  !_strategies[strategy]["filter"]);
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
