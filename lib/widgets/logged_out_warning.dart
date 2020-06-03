import 'package:flutter/material.dart';
import 'package:flutter_loja_online/UI/login_screen.dart';

class LoggedOutWarning extends StatelessWidget {
  final String _message;
  final IconData _icon;

  LoggedOutWarning(this._message, this._icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            _icon,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            _message,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 44,
            child: RaisedButton(
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 18),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          )
        ],
      ),
    );
  }
}
