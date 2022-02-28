import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 150),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.yellow,
        ),
      ),
    );
  }
}