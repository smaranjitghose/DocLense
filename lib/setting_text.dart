import 'package:flutter/material.dart';

class SettingText extends StatelessWidget {
  SettingText({@required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            height: 1,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}