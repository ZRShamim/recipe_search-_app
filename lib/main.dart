import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search_app/pages/hompage.dart';
import 'package:recipe_search_app/pages/recipe_details.dart';
import 'package:recipe_search_app/pages/splash_screen.dart';
import 'package:recipe_search_app/providers/recipe_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => RecipesProvieder(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Search Recipe',
        home: SplashScreen(),
        routes: {
          HomePage.routeName: (ctx) => HomePage(),
          RecipeDetails.routeName: (ctx) => RecipeDetails(),
        },
      ),
    );
  }
}

