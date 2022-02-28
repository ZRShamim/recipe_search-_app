import 'package:flutter/material.dart';

class FavAllChangeBtn extends StatelessWidget {
  String text;

  FavAllChangeBtn(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Colors.black54
      ),
    );
  }
}