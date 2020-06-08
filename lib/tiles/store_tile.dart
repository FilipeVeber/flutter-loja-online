import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreTile extends StatelessWidget {
  final DocumentSnapshot store;

  StoreTile(this.store);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
              height: 100,
              child: Image.network(
                store.data["image"],
                fit: BoxFit.cover,
              )),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  store.data["title"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(store.data["address"]),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.map),
                  color: Colors.blue,
                  onPressed: () {
                    launch(
                        "https://www.google.com/maps/search/?api=1&query=${store.data["lat"]},${store.data["lng"]}");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.blue,
                  onPressed: () {
                    launch("tel:${store.data["phone"]}");
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
