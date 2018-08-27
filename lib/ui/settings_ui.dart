import 'package:flutter/material.dart';
import 'package:trade_buddy/main.dart' as main;
import 'package:trade_buddy/ui/instruction_ui.dart';
import 'package:trade_buddy/ui/legal/legal_ui.dart';
import 'package:trade_buddy/ui/login_ui.dart';
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
          onTap: () {
            if(SettingsController.currentAccount == null) return;
            showDialog(
              context: context,
              builder: (BuildContext context) => _showAccountsDialog(),
            );
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
          onTap: () {
            if(SettingsController.balance == null) return;
            showDialog(
                context: context,
                builder: (BuildContext context) => _showBalanceDialog());
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
                  builder: (BuildContext context) => _showLogoutDialog());
            }),
        Divider(height: 1.0),
      ],
    );
  }

  AlertDialog _showAccountsDialog() {
    return AlertDialog(
      title: Text("Choose Account"),
      content: ListView(
        shrinkWrap: true,
        children: SettingsController.accounts?.keys?.map((account) {
              return Card(
                elevation: 1.0,
                color: SettingsController.currentAccount == account
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                child: ListTile(
                  title: Text("$account"),
                  onTap: () {
                    if (SettingsController.currentAccount != account) {
                      SettingsController.currentAccount = account;
                    }
                    Navigator.pop(context);
                  },
                ),
              );
            })?.toList() ??
            [Text("No Accounts found...")],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  AlertDialog _showBalanceDialog() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _textController = TextEditingController();

    return AlertDialog(
      title: Text("Set Starting Balance"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
              "The starting balance is relevant for the calculation of the maximum drawdown in percent."),
          Form(
            key: _formKey,
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLines: 1,
              controller: _textController,
              validator: (text) {
                if (!isNumeric(text)) {
                  return "Please enter a valid number";
                }
              },
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Confirm"),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              setState(() {
                SettingsController.balance =
                    double.tryParse(_textController.text);
              });
              Navigator.pop(context);
            }
          },
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  AlertDialog _showLogoutDialog() {
    return AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure that you want to logout?"),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Auth.signOut().then((b) {
              if (b) {
                main.isLoaded = false;
                main.isSignedIn = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()),
                    (_) => false);
              }
            });
          },
        ),
        FlatButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
