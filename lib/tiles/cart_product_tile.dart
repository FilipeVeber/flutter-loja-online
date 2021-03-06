import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_online/datas/cart_product.dart';
import 'package:flutter_loja_online/datas/product_data.dart';
import 'package:flutter_loja_online/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartProductTile extends StatelessWidget {
  final CartProduct _cartProduct;
  final cardKey = GlobalKey();

  CartProductTile(this._cartProduct);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: cardKey,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: _cartProduct.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection("products")
                  .document(_cartProduct.category)
                  .collection("items")
                  .document(_cartProduct.productId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _cartProduct.productData =
                      ProductData.fromDocument(snapshot.data);
                  return _buildContent(context);
                } else {
                  return Container(
                    height: 70,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              },
            )
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
//    CartModel.of(context).updateCartSummaryPrices();

    return ScopedModelDescendant<CartModel>(
      builder: (context, child, cartModel) {
        cartModel.updateCartSummaryPrices();
        return Container(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                width: 120,
                child: Image.network(
                  _cartProduct.productData.images[0],
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _cartProduct.productData.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                      Text("Tamanho: ${_cartProduct.size}",
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      Text(
                          "R\$ ${_cartProduct.productData.price.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            color: Theme.of(context).primaryColor,
                            onPressed: _cartProduct.quantity > 1
                                ? () {
                                    cartModel
                                        .decrementItemQuantity(_cartProduct);
                                  }
                                : null,
                          ),
                          Text(_cartProduct.quantity.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              cartModel.incrementItemQuantity(_cartProduct);
                            },
                          ),
                          FlatButton(
                            child: Text("Remover"),
                            textColor: Colors.grey[700],
                            onPressed: () {
                              cartModel.removeCartItem(_cartProduct);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
