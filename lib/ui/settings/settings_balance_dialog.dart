import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/settings_controller.dart';

class BalanceDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}