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
            if (SettingsController.currentAccount == null) return;
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
            if (SettingsController.balance == null) return;
            showDialog(
                context: context,
                builder: (BuildContext context) => _showBalanceDialog());
          },
        ),
        Divider(height: 1.0),
        ListTile(
          leading: Icon(Icons.build),
          title: Text("Strategies"),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => _showStrategiesDialog());
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
      title: Text("Starting Balance"),
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

  AlertDialog _showStrategiesDialog() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _controllerStrategie = TextEditingController();
    final TextEditingController _controllerAbbreviation =
        TextEditingController();

    return AlertDialog(
      title: Text("Strategies"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder(
              initialData: SettingsController.strategies,
              stream: SettingsController.strategiesStream,
              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) =>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data?.keys?.map((strategy) {
                          return Dismissible(
                            key: Key(strategy),
                            onDismissed: (direction) =>
                                SettingsController.removeStrategiy(strategy),
                            child: FlatButton(
                              child:
                                  Text("$strategy,${snapshot.data[strategy]}"),
                              onPressed: () {},
                            ),
                          );
                        })?.toList() ??
                        [
                          Container(
                            height: 0.0,
                            width: 0.0,
                          )
                        ],
                  ),
            ),
            Form(
              key: _formKey,
              child: Row(children: <Widget>[
                Flexible(
                    flex: 5,
                    child: TextFormField(
                      maxLines: 1,
                      controller: _controllerStrategie,
                      validator: (text) {
                        if (text.length < 3) {
                          return "Please enter a strategy";
                        }
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                ),
                Flexible(
                    flex: 2,
                    child: TextFormField(
                      maxLines: 1,
                      controller: _controllerAbbreviation,
                      validator: (text) {
                        if (text.length < 3) {
                          return "Please enter a abbreviation";
                        }
                      },
                    )),
                Flexible(
                  flex: 1,
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 0.1),
                    child: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        SettingsController.addStrategiy({
                          _controllerStrategie.text:
                              _controllerAbbreviation.text
                        });
                        _controllerStrategie.clear();
                        _controllerAbbreviation.clear();
                      }
                    },
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Confirm"),
          onPressed: () {
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

  AlertDialog _showLogoutDialog() {
    return AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure that you want to logout?"),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Confirm",
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
