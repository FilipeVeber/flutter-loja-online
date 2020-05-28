import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'UI/home_screen.dart';
import 'models/user_model.dart';

void main() {
  runApp(ScopedModel<UserModel>(
    model: UserModel(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromARGB(255, 4, 125, 141)),
      title: "Loja virtual",
      home: HomeScreen(),
    ),
  ));
}
