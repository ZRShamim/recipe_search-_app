import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search_app/providers/recipe_provider.dart';
import 'package:recipe_search_app/widgets/fav_all_change_btn.dart';
import 'package:recipe_search_app/widgets/recipe_grid.dart';
import 'package:recipe_search_app/widgets/result_title.dart';
import 'package:recipe_search_app/widgets/progress_indicator.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isLoading = false;
  var _showFav = false;
  var _showAll = true;
  var _isInit = true;
  TextEditingController myController = TextEditingController();
  Future<void> loadData(String cat) async {
    // print(cat);
    setState(() {
      _isLoading = true;
    });
    try {
      // print(cat);
      await Provider.of<RecipesProvieder>(context, listen: false)
          .fetchAndSetRecipeCategory(myController.text, cat);
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An Error Occurred'),
                content: const Text('Something went Wrong'),
                actions: [
                  TextButton(
                    child: const Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<RecipesProvieder>(context, listen: false)
          .fetchAndSetSavedRecipe()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Provider.of<RecipesProvieder>(context, listen: false)
          .fetchAndSetRecipeCategories();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<RecipesProvieder>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello John',
              style: TextStyle(fontSize: 20, fontFamily: 'Nunito'),
            ),
            const Text(
              'Ready to cook?',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        cursorColor: Colors.white30,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        controller: myController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Find Recipe',
                            hintStyle:
                                TextStyle(fontFamily: 'Nunito', fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.yellow,
                    ),
                    child: IconButton(
                        onPressed: () {
                          loadData('All');
                        },
                        icon: const Icon(Icons.search)))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.categories.length,
                itemBuilder: (ctx, index) {
                  return Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(50)),
                      child: TextButton(
                          onPressed: () {
                            loadData(data.categories[index].categoryName);
                          },
                          child: Text(
                            data.categories[index].categoryName,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                color: Colors.black,
                                fontWeight: FontWeight.w500
                                ),
                          )));
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _showAll
                    ? ResultTitle('Search Result')
                    : ResultTitle('Saved Recipe'),
                _showAll
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            _showFav = true;
                            _showAll = false;
                          });
                        },
                        child: FavAllChangeBtn('Show Saved'),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _showFav = false;
                            _showAll = true;
                          });
                        },
                        child: FavAllChangeBtn('See All'),
                      ),
              ],
            ),
            if (_showFav)
              _isLoading
                  ? ProgressIndicatorWidget()
                  : data.recipesFav.isEmpty? const Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Center(
                        child: Text(
                          'No Saved Recipe',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ) : RecipeGrid(recipe: data.recipesFav)
            else
              myController.text.isEmpty || data.recipes.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Center(
                        child: Text(
                          'Search For Recipe',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  : _isLoading
                      ? ProgressIndicatorWidget()
                      : RecipeGrid(recipe: data.recipes)
          ],
        ),
      ),
    );
  }
}
