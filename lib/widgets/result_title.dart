import 'package:flutter/material.dart';

class ResultTitle extends StatelessWidget {
  String text;

  ResultTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: const TextStyle(
          fontFamily: 'Lora',
          fontWeight: FontWeight.w700,
          fontSize: 25,
        ),
      );
  }
}