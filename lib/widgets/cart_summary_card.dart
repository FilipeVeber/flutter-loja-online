import 'package:flutter/material.dart';
import 'package:flutter_loja_online/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartSummaryCard extends StatelessWidget {
  final VoidCallback finishOrder;

  CartSummaryCard(this.finishOrder);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(18),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, cartModel) {
            double productsPrice = cartModel.getProductsPrice();
            double shipPrice = cartModel.getShipPrice();
            double discountPrice = cartModel.getDiscountPrice();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Resumo do pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Subtotal"),
                    Text("R\$ ${productsPrice.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Descontos"),
                    discountPrice > 0
                        ? Text(
                            "R\$ -${discountPrice.toStringAsFixed(2)}",
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          )
                        : Text("R\$ ${discountPrice.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Frete"),
                    Text("R\$ ${shipPrice.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "R\$ ${(productsPrice + shipPrice - discountPrice).toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                RaisedButton(
                  child: Text("Finalizar pedido"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {},
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
