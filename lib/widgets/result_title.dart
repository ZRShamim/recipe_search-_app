import 'package:flutter/material.dart';

class ResultTitle extends StatelessWidget {
  final String text;

  const ResultTitle(this.text, {Key? key}) : super(key: key);

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