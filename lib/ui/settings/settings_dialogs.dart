import 'package:flutter/material.dart';
import 'package:trade_buddy/ui/login_ui.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:trade_buddy/main.dart' as main;
import 'package:trade_buddy/utils/settings_controller.dart';

AlertDialog showAccountsDialog(BuildContext context) {
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
                SettingsController.currentAccount = account;
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

AlertDialog showBalanceDialog(BuildContext context) {
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
              SettingsController.balance =
                  double.tryParse(_textController.text);
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

AlertDialog showStrategiesDialog(BuildContext context) {
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
                      if (text.length < 3 || text.length > 15) {
                        return "Strategy (3-15 letters)";
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
                      if (text.length < 3 || text.length > 5) {
                        return "3-5 letters";
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

AlertDialog showLogoutDialog(BuildContext context) {
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