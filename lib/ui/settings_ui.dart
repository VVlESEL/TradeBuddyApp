import 'package:flutter/material.dart';
import 'package:trade_buddy/ui/accounts_ui.dart';
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
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Accounts()));
          },
        ),
        Divider(height: 1.0),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text("Starting Balance"),
          onTap: () {
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
          onTap: () {
            Auth.signOut().then((b) {
              if (b)
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()),
                    (_) => false);
            });
          },
        ),
        Divider(height: 1.0),
      ],
    );
  }

  AlertDialog _showBalanceDialog() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _textController = TextEditingController();

    return AlertDialog(
      title: Text("Set Starting Balance"),
      content: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text(
              "The starting balance is relevant for the calculation of the maximum drawdown in percent."),
          Form(
            key: _formKey,
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: _textController,
              validator: (text) {
                if (!isNumeric(text)) {
                  return "Please enter a valid number";
                }
              },
              decoration: InputDecoration(
                hintText: "${SettingsController.balance}",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Confirm"),
          onPressed: () {
            print(_formKey.currentState.validate());
            print(double.tryParse(_textController.text));
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
