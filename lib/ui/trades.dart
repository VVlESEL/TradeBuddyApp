import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Trades extends StatefulWidget {
  @override
  _TradesState createState() => _TradesState();
}

class _TradesState extends State<Trades> {
  final DatabaseReference reference = FirebaseDatabase.instance
      .reference()
      .child("user/${Auth.user.uid}/trades");

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FirebaseAnimatedList(
      query: reference,
      padding: const EdgeInsets.all(8.0),
      sort: (a, b) => b.value["closetime"]
          .toString()
          .compareTo(a.value["closetime"].toString()),
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int pos) {
        return Trade(
          snapshot: snapshot,
          animation: animation,
        );
      },
    ));
  }
}

class Trade extends StatelessWidget {
  final DataSnapshot snapshot;
  final Animation animation;

  Trade({this.snapshot, this.animation});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: Column(
        children: <Widget>[
          ExpansionTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      snapshot.value["symbol"],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " ${snapshot.value["type"]} ${snapshot.value["lots"]}",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: snapshot.value["type"].toString() == "buy"
                            ? Colors.blueAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                Text("${snapshot.value["openprice"]} => ${snapshot
                    .value["closeprice"]}"),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(snapshot.value["closetime"]),
                Text(
                  snapshot.value["profit"],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: double.parse(snapshot.value["profit"]) > 0
                        ? Colors.blueAccent
                        : Colors.redAccent,
                  ),
                ),
              ],
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("${snapshot.value["opentime"]}, "),
                        Text(snapshot.value["commentary"]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("SL:"),
                            Text("TP:"),
                            Text("ID:"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(snapshot.value["stoploss"]),
                            Text(snapshot.value["takeprofit"]),
                            Text(snapshot.key),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Swap:"),
                            Text("Commissions:"),
                            Text(""),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(snapshot.value["swap"]),
                            Text(snapshot.value["commission"]),
                            Text(""),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
