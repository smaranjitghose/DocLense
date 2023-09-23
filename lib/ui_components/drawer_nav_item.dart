import "package:doclense/configs/app_dimensions.dart";
import "package:doclense/configs/app_typography.dart";
import "package:flutter/material.dart";

class DrawerNavItem extends StatelessWidget {

  const DrawerNavItem({
    required this.callback,
    required this.iconData,
    required this.navItemTitle,
    super.key,
  });
  final VoidCallback callback;
  final IconData iconData;
  final String navItemTitle;

  @override
  Widget build(BuildContext context) => ListTile(
      onTap: callback,
      leading: Icon(iconData, size: AppDimensions.font(13)),
      title: Text(
        navItemTitle,
        style: AppText.b2,
      ),
    );
}
