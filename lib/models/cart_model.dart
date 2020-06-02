import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_loja_online/datas/cart_product.dart';
import 'package:flutter_loja_online/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  bool isLoading = false;

  String couponCode;
  int discountPercentage = 0;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    products = query.documents.map((item) {
      return CartProduct.fromDocument(item);
    }).toList();

    notifyListeners();
  }

  void addCartItem(CartProduct product) async {
    products.add(product);

    DocumentReference doc = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(product.toMap());

    product.cartId = doc.documentID;

    notifyListeners();
  }

  void removeCartItem(CartProduct product) async {
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(product.cartId)
        .delete();

    products.remove(product);

    notifyListeners();
  }

  void decrementItemQuantity(CartProduct cartProduct) {
    cartProduct.quantity--;

    updateCartProductDatabase(cartProduct);
  }

  void incrementItemQuantity(CartProduct cartProduct) {
    cartProduct.quantity++;

    updateCartProductDatabase(cartProduct);
  }

  void updateCartProductDatabase(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cartId)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updateCartSummaryPrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double productsPrice = 0;

    for (CartProduct cartProduct in products) {
      if (cartProduct.productData != null) {
        productsPrice += cartProduct.quantity * cartProduct.productData.price;
      }
    }

    return productsPrice;
  }

  double getShipPrice() {
    return 9.99;
  }

  double getDiscountPrice() {
    return getProductsPrice() * discountPercentage / 100;
  }
}
