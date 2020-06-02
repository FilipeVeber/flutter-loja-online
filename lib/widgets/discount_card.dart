import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_online/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Cupom de desconto",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu cupom"),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (value) {
                Firestore.instance
                    .collection("coupons")
                    .document(value)
                    .get()
                    .then((document) {
                  if (document.data != null) {
                    var percent = document.data["percent"];

                    CartModel.of(context).setCoupon(value, percent);
                    showCouponValidationMessage(
                        context,
                        "Desconto de ${percent}% aplicado!",
                        Theme.of(context).primaryColor);
                  } else {
                    showCouponValidationMessage(context,
                        "Este cupom não existe", Theme.of(context).errorColor);
                  }
                }).catchError((error) {
                  showCouponValidationMessage(
                      context,
                      "Erro ao validar cupom. Mensagem: ${error.toString()}",
                      Theme.of(context).errorColor);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void showCouponValidationMessage(
      BuildContext context, String message, Color backgroundColor) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }
}
