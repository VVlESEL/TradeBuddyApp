import 'package:flutter/material.dart';
import 'package:trade_buddy/utils/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Trades extends StatefulWidget {
  @override
  _TradesState createState() => _TradesState();
}

class _TradesState extends State<Trades> {
  final DatabaseReference reference =
      FirebaseDatabase.instance.reference().child(Auth.user.uid);

  @override
  void initState() {
    super.initState();
    //init the database entry if it does not exist
    reference.once().then((snapshot){
      if(snapshot.value == null) {
        reference.parent().set({Auth.user.uid: "init"});
      }
    });
  }

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
          ListTile(
            trailing: Text(
              snapshot.value["profit"],
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: double.parse(snapshot.value["profit"]) > 0
                    ? Colors.blueAccent
                    : Colors.redAccent,
              ),
            ),
            title: Row(
              children: <Widget>[
                Text(snapshot.value["symbol"], style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),),
                Text(
                  ", ${snapshot.value["type"]} ${snapshot.value["lots"]}",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: snapshot.value["type"].toString() == "buy"
                        ? Colors.blueAccent
                        : Colors.redAccent,
                  ),
                ),
              ],
            ),
            subtitle: Text("${snapshot.value["openprice"]} => ${snapshot
                .value["closeprice"]}"),
          ),
          Divider(height: 1.0,),
        ],
      ),
    );
  }
}
