import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_search_app/providers/recipe_provider.dart';
import 'package:recipe_search_app/widgets/recipe_grid.dart';

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
  TextEditingController mycontroller = TextEditingController();
  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<RecipesProvieder>(context, listen: false)
          .fetchAndSetRecipe(mycontroller.text);
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
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<RecipesProvieder>(context);
    return Scaffold(
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
                        controller: mycontroller,
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
                          loadData();
                        },
                        icon: const Icon(Icons.search)))
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recomended',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
                _showAll
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            _showFav = true;
                            _showAll = false;
                          });
                        },
                        child: const Text(
                          'Show Saved',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _showFav = false;
                            _showAll = true;
                          });
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
              ],
            ),
            if (_showFav)
              _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      ),
                    )
                  : RecipeGrid(recipe: data.recipesFav)
            else
              mycontroller.text.isEmpty
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
                      ? const Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.yellow,
                            ),
                          ),
                        )
                      : RecipeGrid(recipe: data.recipes)
          ],
        ),
      ),
    );
  }
}
