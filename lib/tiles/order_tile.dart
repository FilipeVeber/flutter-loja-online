import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderID;

  OrderTile(this.orderID);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection("orders")
                .document(orderID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Pedido: ${snapshot.data.documentID}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(_buildProductsInfo(snapshot.data)),
                      ],
                    ),
                  )
                ],
              );
            },
          )),
    );
  }

  String _buildProductsInfo(DocumentSnapshot snapshot) {
    String info = "Descrição:\n";

    for (LinkedHashMap item in snapshot.data["products"]) {
      info +=
          "${item["quantity"]} x ${item["product"]["title"]} (R\$ ${item["product"]["price"].toString()})\n";
    }
    info += "Total: R\$ ${snapshot.data["totalPrice"].toString()}";

    return info;
  }
}
