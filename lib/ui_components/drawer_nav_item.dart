import 'package:flutter/material.dart';

class DrawerNavItem extends StatelessWidget {
  final VoidCallback callback;
  final IconData iconData;
  final String navItemTitle;

  const DrawerNavItem({
    required this.callback,
    required this.iconData,
    required this.navItemTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: callback,
      leading: Icon(iconData),
      title: Text(
        navItemTitle,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
