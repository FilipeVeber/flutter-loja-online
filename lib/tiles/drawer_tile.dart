import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData _icon;
  final String _description;

  DrawerTile(this._icon, this._description);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(
                _icon,
                size: 32,
                color: Colors.black,
              ),
              SizedBox(
                width: 32,
              ),
              Text(
                _description,
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
