import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_search_app/providers/recipe.dart';
import 'package:http/http.dart' as http;

class RecipesProvieder with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes {
    return [..._recipes];
  }

  List<Recipe> _recipesFav = [];

  List<Recipe> get recipesFav {
    return [..._recipesFav];
  }

  // List<Recipe> get favoriteItems {
  //   return _recipes.where((recipe) => recipe.isFavorite == true).toList();
  // }
// fetch data from mealDB
  Future<void> fetchAndSetRecipe(String text) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$text';
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      final extractedData = data['meals'];
      final List<Recipe> _loadedRecipe = [];

      if (extractedData == null) {
        return;
      }
      extractedData.asMap().forEach((key, data) {
        _loadedRecipe.add(Recipe(
          recipeId: data['idMeal'],
          recipeName: data['strMeal'],
          recipeImage: data['strMealThumb'],
          recipeDescription: data['strInstructions'],
          recipeCategory: data['strCategory'],
          recipeArea: data['strArea'],
        ));
      });
      _recipes = _loadedRecipe;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Save recipe in firbase
  Future<void> saveRecipe(
      String recipeId,
      String recipeName,
      String recipeImage,
      String recipeDescription,
      String recipeCategory,
      String recipeArea) async {
    const url =
        'https://recipesearchapp-aada5-default-rtdb.asia-southeast1.firebasedatabase.app/favorite.json';
    // First checking if the saved reciped has been saved before so fetching the existing data from firebase
    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>?;
      final List<Recipe> _loadedRecipe = [];
      // If the firbase is not null, so checking if the saved recipe existed in firbase
      if (extractedData != null) {
        extractedData.forEach((key, data) async {
          if (recipeId != data['recipeId']) {
            try {
              final respon = await http.post(
                Uri.parse(url),
                body: json.encode({
                  'recipeId': recipeId,
                  'recipeName': recipeName,
                  'recipeImage': recipeImage,
                  'recipeDescription': recipeDescription,
                  'recipeCategory': recipeCategory,
                  'recipeArea': recipeArea,
                  'isSave': true,
                }),
              );
              final newSave = Recipe(
                  recipeId: recipeId,
                  saveId: json.decode(respon.body)['name'],
                  recipeName: recipeName,
                  recipeImage: recipeImage,
                  recipeDescription: recipeDescription,
                  recipeCategory: recipeCategory,
                  recipeArea: recipeArea,
                  isSaved: true);
              _recipesFav.add(newSave);
              notifyListeners();
            } catch (error) {
              rethrow;
            }
          }
        });
        _recipes = _loadedRecipe;
        notifyListeners();
        // if the fire base is null so save the recipe
      } else {
        try {
          final response = await http.post(
            Uri.parse(url),
            body: json.encode({
              'recipeId': recipeId,
              'recipeName': recipeName,
              'recipeImage': recipeImage,
              'recipeDescription': recipeDescription,
              'recipeCategory': recipeCategory,
              'recipeArea': recipeArea,
              'isSave': true,
            }),
          );
          final newSave = Recipe(
              recipeId: recipeId,
              saveId: json.decode(response.body)['name'],
              recipeName: recipeName,
              recipeImage: recipeImage,
              recipeDescription: recipeDescription,
              recipeCategory: recipeCategory,
              recipeArea: recipeArea,
              isSaved: true);
          _recipesFav.add(newSave);
          notifyListeners();
        } catch (error) {
          rethrow;
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  // Fetch the saved recipe from firebase
  Future<void> fetchAndSetSavedRecipe() async {
    const url =
        'https://recipesearchapp-aada5-default-rtdb.asia-southeast1.firebasedatabase.app/favorite.json';
    try {
      final respons = await http.get(Uri.parse(url));
      final extractedData = json.decode(respons.body) as Map<String, dynamic>?;
      final List<Recipe> loadedRecipe = [];
      if (extractedData != null) {
        extractedData.forEach((key, data) {
          loadedRecipe.add(Recipe(
              recipeId: data['recipeId'],
              recipeName: data['recipeName'],
              recipeImage: data['recipeImage'],
              recipeDescription: data['recipeDescription'],
              recipeCategory: data['recipeCategory'],
              recipeArea: data['recipeArea']));
        });
        _recipesFav = loadedRecipe;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  // Didn't implemented yet
  Future<void> deleteProduct(String saveId) async {
    final url =
        'https://shop-app-zrs-default-rtdb.asia-southeast1.firebasedatabase.app/products/$saveId.json';
    final existingProductIndex = _recipesFav.indexWhere((item) => item.saveId == saveId);
    Recipe? existingProduct = _recipesFav[existingProductIndex];
    _recipesFav.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _recipesFav.insert(existingProductIndex, existingProduct);
      notifyListeners();
    }
    existingProduct = null;
  }
}
