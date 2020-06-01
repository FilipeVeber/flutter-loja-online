import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_online/UI/login_screen.dart';
import 'package:flutter_loja_online/datas/cart_product.dart';
import 'package:flutter_loja_online/datas/product_data.dart';
import 'package:flutter_loja_online/models/cart_model.dart';
import 'package:flutter_loja_online/models/user_model.dart';

class ProductScreen extends StatefulWidget {
  final ProductData _productData;

  ProductScreen(this._productData);

  @override
  _ProductScreenState createState() => _ProductScreenState(_productData);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData _product;

  _ProductScreenState(this._product);

  String _selectedSize;

  @override
  Widget build(BuildContext context) {
    final Color _primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: _product.images.map((url) => NetworkImage(url)).toList(),
              dotSize: 4,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: _primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _product.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$${_product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5),
                    children: _product.sizes
                        .map((size) => GestureDetector(
                              child: Container(
                                width: 50,
                                alignment: Alignment.center,
                                child: Text(size),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        color: size == _selectedSize
                                            ? _primaryColor
                                            : Colors.grey,
                                        width: 2,
                                        style: BorderStyle.solid)),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedSize = size;
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao carrinho"
                          : "Entre para comprar",
                      style: TextStyle(fontSize: 18),
                    ),
                    color: _primaryColor,
                    textColor: Colors.white,
                    onPressed: _selectedSize == null
                        ? null
                        : () {
                            if (UserModel.of(context).isLoggedIn()) {
                              CartProduct cartProduct = CartProduct();
                              cartProduct.size = _selectedSize;
                              cartProduct.quantity = 1;
                              cartProduct.productId = _product.id;
                              cartProduct.category = _product.categoryID;

                              CartModel.of(context).addCartItem(cartProduct);
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen()));
                            }
                          },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  _product.description,
                  style: TextStyle(fontSize: 16),
                  maxLines: 3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
