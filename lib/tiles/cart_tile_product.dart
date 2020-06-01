import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_online/datas/cart_product.dart';
import 'package:flutter_loja_online/datas/product_data.dart';

class CartTileProduct extends StatelessWidget {
  final CartProduct _cartProduct;

  CartTileProduct(this._cartProduct);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  return _buildContent();
                } else {
                  return Container(
                    height: 70,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              },
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Container();
  }
}
