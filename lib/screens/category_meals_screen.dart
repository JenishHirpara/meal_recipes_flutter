import 'package:flutter/material.dart';

import '../widgets/meal_item.dart';
import '../models/meal.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  final List<Meal> availableMeals;

  CategoryMealsScreen(this.availableMeals);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  // if you delete a particular meal you wont see it in categorymeals page but if you go back and then come to the same page again you will see the deleted meals again,
  // this happens because when you go back you basically pop off that page and with it the widgets and its state,
  // when you come to the same page again, although its the same screen, it has a totally new state and widgets

  String categoryTitle;
  List<Meal> displayedMeals;

  // this variable is used here because didChangeDependencies runs whenever setState is called,
  // so when the delete button inside the meal_detail_screen is pressed it calls setState function here,
  // and the didChangeDependencies runs again and basically overrites everything again,
  // by the variable below we restrict the contents of didChangeDependencies to execute only once
  var _loadedInitData = false;

  @override
  void initState() {
    super.initState();
  }

  // we use didChangeDependencies here instead of initState as initState does not work well with context, it gets executed first before the context,
  // and didChangeDependencies executes after the context loads up
  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      final categoryId = routeArgs['id'];
      displayedMeals = widget.availableMeals.where((meal) {
        return meal.categories.contains(categoryId);
      }).toList();
      _loadedInitData = true;
    }
    super.didChangeDependencies();
  }

  // void _removeMeal(String mealId) {
  //   setState(() {
  //     displayedMeals.removeWhere((meal) => meal.id == mealId);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(
            id: displayedMeals[index].id,
            title: displayedMeals[index].title,
            imageUrl: displayedMeals[index].imageUrl,
            duration: displayedMeals[index].duration,
            affordability: displayedMeals[index].affordability,
            complexity: displayedMeals[index].complexity,
          );
        },
        itemCount: displayedMeals.length,
      ),
    );
  }
}
