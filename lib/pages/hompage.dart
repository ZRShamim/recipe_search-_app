import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search_app/providers/recipe_provider.dart';
import 'package:recipe_search_app/widgets/fav_all_change_btn.dart';
import 'package:recipe_search_app/widgets/recipe_grid.dart';
import 'package:recipe_search_app/widgets/result_title.dart';
import 'package:recipe_search_app/widgets/progress_indicator.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';

  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isLoading = false;
  var _showFav = false;
  var _isInit = true;
  var _showCategorySlider = false;
  TextEditingController myController = TextEditingController();
  Future<void> loadData(String cat) async {
    setState(() {
      _showFav = false;
      _isLoading = true;
    });
    try {
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

  void hideKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final data = Provider.of<RecipesProvieder>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        toolbarHeight: isLandscape ? 5 : 30,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hello John',
                      style: TextStyle(fontSize: 20, fontFamily: 'Nunito'),
                    ),
                    Text(
                      'Ready to cook?',
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Lora',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (isLandscape)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showCategorySlider = !_showCategorySlider;
                      });
                    },
                    child: Text(
                      _showCategorySlider ? 'Search' : 'Categories',
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 18),
                    ),
                  )
              ],
            ),
            SizedBox(
              height: isLandscape ? 10 : 25,
            ),
            isLandscape && _showCategorySlider
                ? SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.categories.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(50)),
                            child: TextButton(
                                onPressed: () {
                                  loadData(
                                      data.categories[index].categoryName);
                                },
                                child: Text(
                                  data.categories[index].categoryName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )));
                      },
                    ),
                  )
                : Row(
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
                              textInputAction: TextInputAction.search,
                              keyboardType: TextInputType.text,
                              controller: myController,
                              onEditingComplete: () {
                                loadData('All');
                                hideKeyboard();
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Find Recipe',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Nunito', fontSize: 18)),
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
                                hideKeyboard();
                              },
                              icon: const Icon(Icons.search)))
                    ],
                  ),
            SizedBox(
              height: isLandscape ? 5 : 15,
            ),
            if (!isLandscape)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.categories.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                  fontWeight: FontWeight.w500),
                            )));
                  },
                ),
              ),
            SizedBox(
              height: isLandscape ? 5 : 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _showFav
                    ? ResultTitle('Saved Recipe')
                    : ResultTitle('Search Result'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showFav = !_showFav;
                    });
                  },
                  child: FavAllChangeBtn(_showFav ? 'See All' : 'Show Saved'),
                )
              ],
            ),
            if (_showFav)
              _isLoading
                  ? ProgressIndicatorWidget()
                  : data.recipesFav.isEmpty
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: isLandscape ? 80 : 150),
                          child: const Center(
                            child: Text(
                              'No Saved Recipe',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      : RecipeGrid(recipe: data.recipesFav)
            else
              myController.text.isEmpty || data.recipes.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: isLandscape ? 80 : 150),
                      child: const Center(
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
