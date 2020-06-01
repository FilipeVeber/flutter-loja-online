import 'package:flutter/material.dart';
import 'package:flutter_loja_online/models/cart_model.dart';
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
