import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:recipe_search_app/pages/hompage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: const [
            Icon(
              Icons.restaurant,
              size: 45,
              color: Colors.yellow,
            ),
            Text(
              'Make a Dish',
              style: TextStyle(fontSize: 28, fontFamily: 'Nunito'),
            ),
          ],
        ),
        duration: 2000,
        nextScreen: HomePage(),
        splashTransition: SplashTransition.fadeTransition);
  }
}
