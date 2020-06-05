import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreTile extends StatelessWidget {
  final DocumentSnapshot store;

  StoreTile(this.store);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(store["title"]),
            Text(store["address"]),
          ],
        ),
      ),
    );
    ;
  }
}
