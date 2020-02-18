import 'package:flutter/material.dart';
import 'package:flutter_loja_online/UI/signup_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4, 125, 141)),
    title: "Loja virtual",
    home: SignUpScreen(),
  ));
}
