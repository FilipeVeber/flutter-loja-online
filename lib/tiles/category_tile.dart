import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot _snapshot;

  CategoryTile(this._snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(_snapshot.data["icon"]),
      ),
      title: Text(_snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {},
    );
  }
}
