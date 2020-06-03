import 'package:flutter/material.dart';
import 'package:flutter_loja_online/UI/order_screen.dart';
import 'package:flutter_loja_online/models/cart_model.dart';
import 'package:flutter_loja_online/models/user_model.dart';
import 'package:flutter_loja_online/tiles/cart_product_tile.dart';
import 'package:flutter_loja_online/widgets/cart_summary_card.dart';
import 'package:flutter_loja_online/widgets/discount_card.dart';
import 'package:flutter_loja_online/widgets/logged_out_warning.dart';
import 'package:flutter_loja_online/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, cartModel) {
                return _buildQuantityIndicator(cartModel.products.length);
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, cartModel) {
          if (cartModel.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return LoggedOutWarning("Faça o login para adicionar produtos",
                Icons.remove_shopping_cart);
          } else if (cartModel.products == null ||
              cartModel.products.length == 0) {
            return Center(
              child: Text(
                "Nenhum produto no carrinho",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: cartModel.products.map((product) {
                    return CartProductTile(product);
                  }).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartSummaryCard(() async {
                  String orderId = await cartModel.finishOrder();
                  if (orderId != null) {
                    print("Order ID: $orderId");
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => OrderScreen(orderId)));
                  }
                }),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildQuantityIndicator(int quantity) {
    String label;
    TextStyle style = TextStyle(fontSize: 17);

    if (quantity == null || quantity == 0) {
      label = "VAZIO";
    } else {
      label = "$quantity ${quantity == 1 ? " ITEM" : " ITENS"}";
    }

    return Text(
      label,
      style: style,
    );
  }
}
