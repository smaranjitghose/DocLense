import 'package:flutter/material.dart';

class DrawerNavItem extends StatelessWidget {

  final VoidCallback callback;
  final IconData  iconData;
  final String navItemTitle;

  const DrawerNavItem({
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
          style: const TextStyle(fontSize: 18),
        ),
    );
  }
}