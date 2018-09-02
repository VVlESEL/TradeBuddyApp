import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';

class AccountsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Accounts"),
      content: SingleChildScrollView(
        child: Column(
          children: SettingsController.accounts?.keys?.map((account) {
            return Card(
              elevation: 1.0,
              color: SettingsController.currentAccount == account
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              child: ListTile(
                title: Text("$account"),
                onTap: () {
                  SettingsController.setCurrentAccount(account);
                  Navigator.pop(context);
                },
              ),
            );
          })?.toList() ??
              [Text("No Accounts found...")],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}