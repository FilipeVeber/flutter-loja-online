import 'package:flutter/material.dart';
import 'package:flutter_loja_online/models/user_model.dart';
import 'package:flutter_loja_online/widgets/logged_out_warning.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!UserModel.of(context).isLoggedIn()) {
      return LoggedOutWarning("Faça o login para acompanhar seus pedidos",
          Icons.playlist_add_check);
    } else {
      return _buildOrdersContent(context);
    }
  }

  _buildOrdersContent(BuildContext context) {
    return Container();
  }
}
