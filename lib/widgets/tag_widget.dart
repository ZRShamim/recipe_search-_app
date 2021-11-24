import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  String tag;
  Color color;
  Tag(this.tag, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 85,
        height: 30,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(30)),
        child: Text(tag));
  }
}
