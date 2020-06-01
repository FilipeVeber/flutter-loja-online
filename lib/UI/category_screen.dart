import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_online/datas/product_data.dart';
import 'package:flutter_loja_online/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot _snapshot;

  CategoryScreen(this._snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              _snapshot.data["title"],
            ),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(icon: Icon(Icons.grid_on)),
                Tab(
                  icon: Icon(Icons.list),
                )
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("products")
                .document(_snapshot.documentID)
                .collection("items")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    GridView.builder(
                        padding: EdgeInsets.all(4),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            childAspectRatio: 0.65),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return ProductTile(
                              "grid", _getProductData(snapshot, index));
                        }),
                    ListView.builder(
                        padding: EdgeInsets.all(4),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return ProductTile(
                              "list", _getProductData(snapshot, index));
                        }),
                  ],
                );
              }
            },
          )),
    );
  }

  ProductData _getProductData(snapshot, index) {
    ProductData productData =
        ProductData.fromDocument(snapshot.data.documents[index]);
    productData.categoryID = this._snapshot.documentID;

    return productData;
  }
}
