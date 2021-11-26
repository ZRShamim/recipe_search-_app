import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search_app/providers/recipe_provider.dart';
import 'package:recipe_search_app/widgets/tag_widget.dart';

class RecipeDetails extends StatefulWidget {
  static const routeName = '/recipe-details';

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<RecipesProvieder>(context);
    final recipeData = ModalRoute.of(context)!.settings.arguments as Map;
    final recipeId = recipeData['recipeId'];
    final recipeName = recipeData['recipeName'];
    final recipeImage = recipeData['recipeImage'];
    final recipeDescription = recipeData['recipeDescription'];
    final recipeCategory = recipeData['recipeCategory'];
    final recipeArea = recipeData['recipeArea'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.deepOrangeAccent),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              recipe.saveRecipe(recipeId, recipeName, recipeImage,
                  recipeDescription, recipeCategory, recipeArea);
              setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        recipeName,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Tag(recipeCategory, Colors.orange),
                        const SizedBox(
                          width: 5,
                        ),
                        Tag(recipeArea, Colors.orangeAccent),
                      ],
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    recipeImage,
                    height: 200,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Recipe Preparation',
                style: TextStyle(
                    fontSize: 30, fontFamily: 'Lora', color: Colors.redAccent),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 10, right: 20),
                child: Text(
                  recipeDescription,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 18),
                )),
          ],
        ),
      ),
    );
  }
}
