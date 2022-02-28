import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search_app/providers/recipe_provider.dart';
import 'package:recipe_search_app/widgets/tag_widget.dart';

class RecipeDetails extends StatefulWidget {
  static const routeName = '/recipe-details';

  const RecipeDetails({Key? key}) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final recipe = Provider.of<RecipesProvieder>(context);
    final recipeData = ModalRoute.of(context)!.settings.arguments as Map;
    final recipeId = recipeData['recipeId'];
    final recipeName = recipeData['recipeName'];
    final recipeImage = recipeData['recipeImage'];
    final recipeDescription = recipeData['recipeDescription'];
    final recipeCategory = recipeData['recipeCategory'];
    final recipeArea = recipeData['recipeArea'];
    final isSaved = recipeData['isSaved'];
    final saveId = recipeData['saveId'];

    void removeSavedRecipe() {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to remove the saved recipe?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        var count = 0;
                        recipe.deleteRecipe(saveId);
                        Navigator.of(ctx).popUntil((_) => count++ >= 2);
                      },
                      child: const Text('yes')),
                ],
              ));
    }

    void saveRecipe() {
      recipe.saveRecipe(recipeId, recipeName, recipeImage, recipeDescription,
          recipeCategory, recipeArea);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.deepOrangeAccent),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              !isSaved ? saveRecipe() : removeSavedRecipe();
              setState(() {});
            },
            child: Text(
              isSaved ? 'Saved' : 'Save',
              style: const TextStyle(color: Colors.amber, fontSize: 20),
            ),
          ),
        ],
      ),
      body: isLandscape
          ? LandscapeView(
              recipeImage: recipeImage,
              recipeName: recipeName,
              recipeCategory: recipeCategory,
              recipeArea: recipeArea,
              recipeDescription: recipeDescription)
          : PortraitView(
              recipeName: recipeName,
              recipeCategory: recipeCategory,
              recipeArea: recipeArea,
              recipeImage: recipeImage,
              recipeDescription: recipeDescription),
    );
  }
}

class PortraitView extends StatelessWidget {
  const PortraitView({
    required this.recipeName,
    required this.recipeCategory,
    required this.recipeArea,
    required this.recipeImage,
    required this.recipeDescription,
  });

  final String recipeName;
  final String recipeCategory;
  final String recipeArea;
  final String recipeImage;
  final String recipeDescription;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    width: MediaQuery.of(context).size.width * .25,
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
    );
  }
}

class LandscapeView extends StatelessWidget {
  const LandscapeView({
    required this.recipeImage,
    required this.recipeName,
    required this.recipeCategory,
    required this.recipeArea,
    required this.recipeDescription,
  });

  final String recipeImage;
  final String recipeName;
  final String recipeCategory;
  final String recipeArea;
  final String recipeDescription;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  recipeImage,
                  height: 200,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * .2,
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
        const SizedBox(
          width: 50,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Recipe Preparation',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Lora',
                      color: Colors.redAccent),
                ),
              ),
              Container(
                  // width: 500,
                  width: MediaQuery.of(context).size.width * .6,
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
      ],
    );
  }
}
