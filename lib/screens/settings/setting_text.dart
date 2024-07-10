import "package:doclense/configs/app_typography.dart";
import "package:doclense/configs/space.dart";
import "package:flutter/material.dart";

class SettingText extends StatelessWidget {
  const SettingText({required this.text, super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Expanded(
      flex: 5,
      child: Padding(
        padding: Space.all(),
        child: Text(
          text,
          style: AppText.b2,
        ),
      ),
    );
}
