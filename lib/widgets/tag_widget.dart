import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String tag;
  final Color color;
  const Tag(this.tag, this.color);

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
