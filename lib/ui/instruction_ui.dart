import 'package:flutter/material.dart';

class Instruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Instruction")),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Text(
            "Installing the TradeBuddyWeb Script",
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Text("The script is a small tool that hold the necessary code to "
              "send the trades from the MT4 to the webserver. The trades will "
              "be stored in a database and can be requested by the TradeBuddy "
              "journal. To download the TradeBuddyWeb script use this link:"
              "\n\nhttps://goo.gl/8qE8tP"
              "\n\nThen you have to install the script in your MT4 on your PC. "
              "To do so follow these steps:"),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Image.asset("images/instruction_open_data_folder.png"),
          Divider(height: 50.0),
          Image.asset("images/instruction_mql4.png"),
          Divider(height: 50.0),
          Image.asset("images/instruction_scripts.png"),
          Divider(height: 50.0),
          Image.asset("images/instruction_tradebuddyweb.png"),
          Divider(height: 50.0),
          Text(
            "Preparing the MT4 for trade uploads",
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Text("To use the script it has to be able to send web requests. "
              "In MT4 this has to be allowed first."
              "To do so follow these steps:"),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Image.asset("images/instruction_options.png"),
          Divider(height: 50.0),
          Image.asset("images/instruction_expert_advisors.png"),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Text("Afterwards just double click on the TradeBuddyWeb script in "
              "the MT4 Navigator and enter your login credentials. The script "
              "will then automatically upload the trades and they will be "
              "shown in the trade buddy. Have fun with the tool! :)"),
        ],
      ),
    );
  }
}
