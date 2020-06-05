import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_online/tiles/store_tile.dart';

class StoresTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("stores").getDocuments(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
          default:
            if (!snapshot.hasData) {
              Center(
                child: Text("Nenhuma loja encontrada!"),
              );
            }

            return ListView(
                children: snapshot.data.documents
                    .map((store) => StoreTile(store))
                    .toList());
        }
      },
    );
  }
}
