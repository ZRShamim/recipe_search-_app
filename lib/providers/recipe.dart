import 'package:flutter/material.dart';

class Recipe with ChangeNotifier {
  final String recipeId;
  final String? saveId;
  final String recipeName;
  final String recipeImage;
  final String recipeDescription;
  final String recipeCategory;
  final String recipeArea;
  bool isSaved;

  Recipe({
    required this.recipeId,
    this.saveId,
    required this.recipeName,
    required this.recipeImage,
    required this.recipeDescription,
    required this.recipeCategory,
    required this.recipeArea,
    this.isSaved = false,
  });

  void toggleSave() {
    isSaved = !isSaved;
    notifyListeners();
  }


}
