import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  String tag;
  Color color;
  Tag(this.tag, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(tag, style: TextStyle(
      color: color,
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w700,
      fontSize: 16
    ),);
  }
}
