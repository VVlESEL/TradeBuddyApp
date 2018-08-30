import 'package:flutter/material.dart';
import 'package:trade_buddy/ui/instruction_ui.dart';
import 'package:trade_buddy/ui/legal/legal_ui.dart';
import 'package:trade_buddy/ui/settings/settings_accounts_dialog.dart';
import 'package:trade_buddy/ui/settings/settings_balance_dialog.dart';
import 'package:trade_buddy/ui/settings/settings_logout_dialog.dart';
import 'package:trade_buddy/ui/settings/settings_strategies_dialog.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/utils/settings_controller.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.format_list_numbered),
          title: Text("Accounts"),
          trailing: StreamBuilder(
              initialData: SettingsController.currentAccount,
              stream: SettingsController.currentAccountStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                  Text("${snapshot.data}")),
          onTap: () async {
            if (SettingsController.currentAccount == null) return;
            await showDialog(
                context: context,
                builder: (BuildContext context) => AccountsDialog());
            setState(() {});
          },
        ),
        Divider(height: 1.0),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text("Starting Balance"),
          trailing: StreamBuilder(
              initialData: SettingsController.balance,
              stream: SettingsController.balanceStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                  Text("${snapshot.data}")),
          onTap: () async {
            if (SettingsController.balance == null) return;
            await showDialog(
                context: context,
                builder: (BuildContext context) => BalanceDialog());
            setState(() {});
          },
        ),
        Divider(height: 1.0),
        ListTile(
          leading: Icon(Icons.build),
          title: Text("Strategies"),
          onTap: () {
            if (SettingsController.currentAccount == null) return;
            showDialog(
                context: context,
                builder: (BuildContext context) => StrategiesDialog());
          },
        ),
        Divider(height: 1.0),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text("Instruction"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Instruction()));
          },
        ),
        Divider(height: 1.0),
        ListTile(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Legal())),
          leading: Icon(Icons.info_outline),
          title: Text("Legal"),
        ),
        Divider(height: 1.0),
        ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Sign Out"),
            trailing: Text("${Auth.user.email}"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => LogoutDialog());
            }),
        Divider(height: 1.0),
      ],
    );
  }
}
