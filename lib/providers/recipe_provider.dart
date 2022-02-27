import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_search_app/providers/category.dart';
import 'package:recipe_search_app/providers/recipe.dart';
import 'package:http/http.dart' as http;

class RecipesProvieder with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes {
    return [..._recipes];
  }

  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Recipe> _recipesFav = [];

  List<Recipe> get recipesFav {
    return [..._recipesFav];
  }

// fetch data rcipe data from mealDB
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

  Future<void> saveRecipe(
    String recipeId,
    String recipeName,
    String recipeImage,
    String recipeDescription,
    String recipeCategory,
    String recipeArea,
  ) async {
    const url =
        'https://recipesearchapp-aada5-default-rtdb.asia-southeast1.firebasedatabase.app/favorite.json';
    var _isSaved = false;
    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>?;

      if (extractedData != null) {
        extractedData.forEach((key, data) {
          if (recipeId == data['recipeId']) {
            _isSaved = true;
          }
        });
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
              'isSaved': true,
            }),
          );
          final newSave = Recipe(
            recipeId: recipeId,
            recipeName: recipeName,
            recipeImage: recipeImage,
            recipeDescription: recipeDescription,
            recipeCategory: recipeCategory,
            recipeArea: recipeArea,
            saveId: json.decode(response.body)['name'],
            isSaved: true,
          );
          _recipesFav.add(newSave);
          notifyListeners();
        } catch (error) {
          rethrow;
        }
        return;
      }
      if (!_isSaved) {
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
              'isSaved': true,
            }),
          );
          final newSave = Recipe(
            recipeId: recipeId,
            recipeName: recipeName,
            recipeImage: recipeImage,
            recipeDescription: recipeDescription,
            recipeCategory: recipeCategory,
            recipeArea: recipeArea,
            saveId: json.decode(response.body)['name'],
            isSaved: true,
          );
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

  Future<void> fetchAndSetSavedRecipe() async {
    const url =
        'https://recipesearchapp-aada5-default-rtdb.asia-southeast1.firebasedatabase.app/favorite.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      final List<Recipe> loadedRecipe = [];
      if (extractedData != null) {
        extractedData.forEach((key, data) {
          loadedRecipe.add(Recipe(
              recipeId: data['recipeId'],
              recipeName: data['recipeName'],
              recipeImage: data['recipeImage'],
              recipeDescription: data['recipeDescription'],
              recipeCategory: data['recipeCategory'],
              recipeArea: data['recipeArea'],
              saveId: key,
              isSaved: data['isSaved']));
        });
        _recipesFav = loadedRecipe;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteRecipe(String saveId) async {
    final url =
        'https://recipesearchapp-aada5-default-rtdb.asia-southeast1.firebasedatabase.app/favorite/$saveId.json';
    final existingRecipeIndex =
        _recipesFav.indexWhere((recipe) => recipe.saveId == saveId);
    // print(existingRecipeIndex);
    Recipe? existingRecipe = _recipesFav[existingRecipeIndex];
    _recipesFav.removeAt(existingRecipeIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _recipesFav.insert(existingRecipeIndex, existingRecipe);
      notifyListeners();

      // throw HttpException('Could Not Delete Recipe.');
    }
    existingRecipe = null;
    notifyListeners();
  }

  Future<void> fetchAndSetRecipeCategory(String text, String category) async {
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
        if (category != 'All') {
          if (data['strCategory'] == category) {
            _loadedRecipe.add(Recipe(
              recipeId: data['idMeal'],
              recipeName: data['strMeal'],
              recipeImage: data['strMealThumb'],
              recipeDescription: data['strInstructions'],
              recipeCategory: data['strCategory'],
              recipeArea: data['strArea'],
            ));
          } else {
            return;
          }
        } else {
          _loadedRecipe.add(Recipe(
            recipeId: data['idMeal'],
            recipeName: data['strMeal'],
            recipeImage: data['strMealThumb'],
            recipeDescription: data['strInstructions'],
            recipeCategory: data['strCategory'],
            recipeArea: data['strArea'],
          ));
        }
      });
      _recipes = _loadedRecipe;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetRecipeCategories() async {
    const url = 'https://www.themealdb.com/api/json/v1/1/categories.php';
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      final extractedData = data['categories'];
      final List<Category> _loadedRecipe = [];

      if (extractedData == null) {
        return;
      }
      extractedData.asMap().forEach((key, data) {
        _loadedRecipe.add(Category(categoryName: data['strCategory']));
      });
      _loadedRecipe.insert(0, Category(categoryName: 'All'));
      _categories = _loadedRecipe;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
