import 'package:flutter/material.dart';

class drawerNavItem extends StatelessWidget {

  final VoidCallback callback;
  final IconData  iconData;
  final String navItemTitle;

  drawerNavItem({
    this.callback,
    this.iconData,
    this.navItemTitle,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: callback,
        leading:  Icon(iconData),
        title: Text(
          navItemTitle,
          style: TextStyle(fontSize: 18),
        ),
    );
  }
}