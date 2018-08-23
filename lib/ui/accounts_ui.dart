import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trades_controller.dart';

class Accounts extends StatefulWidget {
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {

  @override
  void dispose() {
    super.dispose();

    TradesController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
      ),
      body: ListView(
        children: SettingsController.accounts.keys.map((account) {
          return Card(
            elevation: 1.0,
            color: SettingsController.currentAccount == account
                ? Theme.of(context).primaryColor
                : Colors.white,
            child: ListTile(
              title: Text("$account"),
              onTap: () {
                if (SettingsController.currentAccount != account) {
                  setState(() {
                    SettingsController.currentAccount = account;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
