import 'package:flutter/material.dart';

class Eula extends StatelessWidget {
  var version = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EULA"),
      ),
      body: ListView(
        children: <Widget>[
          Text(
            "Trade Buddy $version, Copyright (c) 2018 BM Trading GmbH",
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text(
            "*** END USER LICENSE AGREEMENT ***",
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text(
            "IMPORTANT: PLEASE READ THIS LICENSE CAREFULLY BEFORE USING THIS SOFTWARE.",
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text(
            "1. LICENSE",
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("By receiving, opening the file package, and/or using Trade Buddy $version ('Software') containing this software, you agree that this End User User License Agreement(EULA) is a legally binding and valid contract and agree to be bound by it. You agree to abide by the intellectual property laws and all of the terms and conditions of this agreement."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("Unless you have a different license agreement signed by BM Trading GmbH your use of Trade Buddy $version indicates your acceptance of this license agreement and warranty."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("If you do not agree to be bound by this agreement, remove Trade Buddy $version from your mobile/hardware."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text(
            "2. USER AGREEMENT",
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text(
            "2.1 Use Restrictions",
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("You shall use Trade Buddy $version in compliance with all applicable laws and not for any unlawful purpose. Without limiting the foregoing, use, display or distribution of Trade Buddy $version together with material that is pornographic, racist, vulgar, obscene, defamatory, libelous, abusive, promoting hatred, discriminating or displaying prejudice based on religion, ethnic heritage, race, sexual orientation or age is strictly prohibited."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("If any person other than yourself uses Trade Buddy $version registered in your name, regardless of whether it is at the same time or different times, then this agreement is being violated and you are responsible for that violation!"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("2.2 Copyright Restriction", style: TextStyle(fontSize: 20.0),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("This Software contains copyrighted material, trade secrets and other proprietary material. You shall not, and shall not attempt to, modify, reverse engineer, disassemble or decompile Trade Buddy $version. Nor can you create any derivative works or other works that are based upon or derived from Trade Buddy $version in whole or in part."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("BM Trading GmbH's name, logo and graphics file that represents Trade Buddy $version shall not be used in any way to promote products developed with Trade Buddy $version. BM Trading GmbH retains sole and exclusive ownership of all right, title and interest in and to Trade Buddy $version and all Intellectual Property rights relating thereto."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("Copyright law and international copyright treaty provisions protect all parts of Trade Buddy $version, products and services. No program, code, part, image, audio sample, or text may be copied or used in any way by the user except as intended within the bounds of the single user program. All rights not expressly granted hereunder are reserved for BM Trading GmbH."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("2.3 Limitation of Responsibility", style: TextStyle(fontSize: 20.0),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("You will indemnify, hold harmless, and defend BM Trading GmbH , its employees, agents and distributors against any and all claims, proceedings, demand and costs resulting from or in any way connected with your use of BM Trading GmbH's Software."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("In no event (including, without limitation, in the event of negligence) will BM Trading GmbH , its employees, agents or distributors be liable for any consequential, incidental, indirect, special or punitive damages whatsoever (including, without limitation, damages for loss of profits, loss of use, business interruption, loss of information or data, or pecuniary loss), in connection with or arising out of or related to this Agreement, Trade Buddy $version or the use or inability to use Trade Buddy $version or the furnishing, performance or use of any other matters hereunder whether based upon contract, tort or any other theory including negligence."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("2.4 Warranties", style: TextStyle(fontSize: 20.0),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("Except as expressly stated in writing, BM Trading GmbH makes no representation or warranties in respect of this Software and expressly excludes all other warranties, expressed or implied, oral or written, including, without limitation, any implied warranties of merchantable quality or fitness for a particular purpose."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("2.5 Governing Law", style: TextStyle(fontSize: 20.0),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("This Agreement shall be governed by the law of the Germany applicable therein. You hereby irrevocably attorn and submit to the non-exclusive jurisdiction of the courts of Germany therefrom. If any provision shall be considered unlawful, void or otherwise unenforceable, then that provision shall be deemed severable from this License and not affect the validity and enforceability of any other provisions."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("2.6 Termination", style: TextStyle(fontSize: 20.0),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("Any failure to comply with the terms and conditions of this Agreement will result in automatic and immediate termination of this license. Upon termination of this license granted herein for any reason, you agree to immediately cease use of Trade Buddy $version and destroy all copies of Trade Buddy $version supplied under this Agreement. The financial obligations incurred by you shall survive the expiration or termination of this license."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("3. DISCLAIMER OF WARRANTY", style: TextStyle(fontSize: 20.0),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("THIS SOFTWARE AND THE ACCOMPANYING FILES ARE SOLD 'AS IS' AND WITHOUT WARRANTIES AS TO PERFORMANCE OR MERCHANTABILITY OR ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED. THIS DISCLAIMER CONCERNS ALL FILES GENERATED AND EDITED BY Trade Buddy $version AS WELL."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("4. CONSENT OF USE OF DATA", style: TextStyle(fontSize: 20.0),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
          Text("You agree that BM Trading GmbH may collect and use information gathered in any manner as part of the product support services provided to you, if any, related to Trade Buddy $version.BM Trading GmbH may also use this information to provide notices to you which may be of use or interest to you."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
          ),
        ],
      ),
    );
  }
}





