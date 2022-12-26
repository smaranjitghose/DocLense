import 'package:doclense/configs/app_dimensions.dart';
import 'package:doclense/configs/app_typography.dart';
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
      leading: Icon(iconData, size: AppDimensions.font(13)),
      title: Text(
        navItemTitle,
        style: AppText.b2,
      ),
    );
  }
}
