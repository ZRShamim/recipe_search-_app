import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search_app/providers/recipe.dart';
import 'package:recipe_search_app/widgets/recipe_item_widget.dart';

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipe;
  RecipeGrid({
    required this.recipe,
  });


  @override
  Widget build(BuildContext context) {

    return Flexible(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: recipe.length > 20 ? 20 : recipe.length,
          gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1.5,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: recipe[i],
            child: RecipeItem(),
          ),
        ),
      );
  }
}