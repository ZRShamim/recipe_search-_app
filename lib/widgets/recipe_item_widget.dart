import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search_app/pages/recipe_details.dart';
import 'package:recipe_search_app/providers/recipe.dart';
import 'package:recipe_search_app/widgets/tag_widget.dart';

class RecipeItem extends StatelessWidget {
  const RecipeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipe>(context);
    final arg = {
      'recipeId': recipe.recipeId,
      'recipeName': recipe.recipeName,
      'recipeImage': recipe.recipeImage,
      'recipeDescription': recipe.recipeDescription,
      'recipeCategory': recipe.recipeCategory,
      'recipeArea': recipe.recipeArea,
      'isSaved': recipe.isSaved,
      'saveId': recipe.saveId
    };
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RecipeDetails.routeName, arguments: arg);
              },
              child: Image.network(
                recipe.recipeImage,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black.withOpacity(0.65),
              leading: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(RecipeDetails.routeName, arguments: arg);
                },
                child: const Text(
                  'Details',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Tag(recipe.recipeCategory, Colors.yellow),
                  ],
                ),
              ),
              title: Text(
                recipe.recipeName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            )),
      ),
    );
  }
}
