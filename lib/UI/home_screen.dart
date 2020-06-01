import 'package:flutter/material.dart';
import 'package:flutter_loja_online/tabs/category_tab.dart';
import 'package:flutter_loja_online/tabs/home_tab.dart';
import 'package:flutter_loja_online/widgets/cart_button.dart';
import 'package:flutter_loja_online/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: HomeTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Categorias"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: CategoryTab(),
          floatingActionButton: CartButton(),
        ),
        Container(
          color: Colors.green,
        ),
        Container(
          color: Colors.yellow,
        ),
      ],
    );
  }
}
