import 'package:flutter/material.dart';

import 'UI/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4, 125, 141)),
    title: "Loja virtual",
    home: HomeScreen(),
  ));
}
