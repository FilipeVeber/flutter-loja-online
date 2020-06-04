import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_loja_online/models/user_model.dart';
import 'package:flutter_loja_online/tiles/order_tile.dart';
import 'package:flutter_loja_online/widgets/logged_out_warning.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!UserModel.of(context).isLoggedIn()) {
      return LoggedOutWarning("Faça o login para acompanhar seus pedidos",
          Icons.playlist_add_check);
    } else {
      return _buildOrdersContent(context);
    }
  }

  _buildOrdersContent(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance
          .collection("users")
          .document(UserModel.of(context).firebaseUser.uid)
          .collection("orders")
          .getDocuments(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (!snapshot.hasData) {
              return _buildNoDataFoundMessage();
            }

            return ListView(
              children: snapshot.data.documents
                  .map((doc) => OrderTile(doc.documentID))
                  .toList(),
            );

          default:
            return Container();
        }
      },
    );
  }

  Widget _buildNoDataFoundMessage() {
    return Center(
      child: Text("Dados não encontrados"),
    );
  }
}
