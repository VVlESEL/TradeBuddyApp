import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';
import 'package:trade_buddy/utils/trades_controller.dart';

class Accounts extends StatefulWidget {
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  var _selectedAccount = SettingsController.currentAccount;

  @override
  void dispose() {
    super.dispose();

    if (_selectedAccount != SettingsController.currentAccount) {
      SettingsController.currentAccount = _selectedAccount;
      TradesController.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
      ),
      body: ListView(
        children: SettingsController.accounts?.keys?.map((account) {
              return Card(
                elevation: 1.0,
                color: _selectedAccount == account
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                child: ListTile(
                  title: Text("$account"),
                  onTap: () {
                    if (_selectedAccount != account) {
                      setState(() => _selectedAccount = account);
                    }
                  },
                ),
              );
            })?.toList() ??
            [Text("No Accounts found...")],
      ),
    );
  }
}
