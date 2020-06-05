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

              int status = snapshot.data["status"];

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
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          "Status:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildCircleStatus(1, "1", "Preparaçao", status),
                            _buildDivider(),
                            _buildCircleStatus(2, "2", "Transporte", status),
                            _buildDivider(),
                            _buildCircleStatus(3, "3", "Entrega", status),
                          ],
                        ),
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

  Widget _buildCircleStatus(
      int position, String title, String subtitle, int status) {
    Color backgroundColor;
    Widget child;

    if (status < position) {
      backgroundColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == position) {
      backgroundColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backgroundColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: backgroundColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 2,
      width: 40,
      color: Colors.grey[500],
    );
  }
}
