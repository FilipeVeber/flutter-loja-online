import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData _icon;
  final String _description;
  final PageController _pageController;
  final int _page;

  DrawerTile(this._icon, this._description, this._pageController, this._page);

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
                color: _pageController.page.round() == _page
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              SizedBox(
                width: 32,
              ),
              Text(
                _description,
                style: TextStyle(
                  fontSize: 16,
                  color: _pageController.page.round() == _page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          _pageController.jumpToPage(_page);
        },
      ),
    );
  }
}
