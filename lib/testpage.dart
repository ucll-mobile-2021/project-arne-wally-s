
import 'package:abc_cooking/cook/cook_page.dart';
import 'package:abc_cooking/buy/buy_page.dart';
import 'package:abc_cooking/appetite/appetite_page.dart';
import 'package:abc_cooking/models/cart.dart';
import 'package:abc_cooking/models/ingredient_amount.dart';
import 'package:abc_cooking/models/timer.dart';
import 'package:abc_cooking/services/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abc_cooking/models/step.dart' as im;

import 'DB/DB.dart';
import 'models/ingredient.dart';
import 'models/recipe.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyRecipesService(),
      child: MaterialApp(
        title: 'ABC Cooking',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: createMaterialColor(Color(0xFF222222)),
          accentColor: Colors.deepOrange,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  RecipeHelper _recipeHelper= RecipeHelper();
  static List<Widget> _pages = <Widget>[
    AppetiteWidget(),
    BuyWidget(),
    CookWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //button
    //_recipeHelper.insertRecipe(widget.recipe);
    return Scaffold(body: Center( child: Column(children:<Widget>[
      Center( child: RaisedButton(
        child: Text("recipe"),
        onPressed: () {
          _recipeHelper.initializeDatabase().then((value) async {
            print('--------DB recipe ready----------');
            await _recipeHelper.deleteAllRecipes();
            await _recipeHelper.ingredients();
            Ingredient ingredient = new Ingredient("name", "measurement_unit", "type", 3.5, "picture");
            List<Ingredientamount> list;
            List<im.Step> list2;
            //var list = new List(1);
            list = new List(1);
            list2 = new List(1);
            list[0] = Ingredientamount(ingredient,1.0);
            im.Step step = new im.Step(1,"a","b",1);
            list2[0] = step;
            _recipeHelper.insertRecipe(new Recipe("id3","name",3,true,true,1,30,2,list,list2,"picture" ));
            var recipe = await _recipeHelper.getRecipe("id3");
            //_recipeHelper.deleteRecipe("id2");
          });
          // Set default people to latest used value

        },)
      ),
      Center( child: RaisedButton(
        child: Text("step"),
        onPressed: () {
          _recipeHelper.initializeDatabase().then((value){
            print('--------DB step ready----------');

            im.Step step = new im.Step(1,"a","b",1);
            _recipeHelper.insertStep(step,null);
            //_recipeHelper.deleteAllSteps();
            print(_recipeHelper.steps());
            //_recipeHelper.deleteRecipe("id2");
          });
          // Set default people to latest used value

        },)
      ),
      Center( child: RaisedButton(
        child: Text("ingredient"),
        onPressed: () {
          _recipeHelper.initializeDatabase().then((value) async {
            print('--------DB ingredient ready----------');

            Ingredient ingredient = new Ingredient("name","U","type",3.3,"picture");
            _recipeHelper.insertIngredient(ingredient);
            _recipeHelper.ingredients();
            Ingredient t = await _recipeHelper.getIngredient("name");
            print(t);

            //_recipeHelper.deleteAllIngredients();
          });
        },)
      ),Center( child: RaisedButton(
        child: Text("ingredientAmount"),
        onPressed: () {
          _recipeHelper.initializeDatabase().then((value) async{
            print('--------DB ingredientAmount ready----------');
            //_recipeHelper.deleteAllIngredients();
            Ingredient ingredient = new Ingredient("name","U","type",3.3,"picture");
            Ingredientamount ingredientamount= new Ingredientamount(ingredient,2.5);
            _recipeHelper.insertIngredientAmount(ingredientamount);
            List<Ingredientamount> list = await _recipeHelper.ingredientAmounts();
            print("name : " + list[0].ingredient.name);
            print("unit : " + list[0].ingredient.measurement_unit);
            print("price : " + list[0].ingredient.price.toString());
          });
        },)
      ),Center( child: RaisedButton(
        child: Text("timer"),
        onPressed: () {
          _recipeHelper.initializeDatabase().then((value) async{
            print('--------DB timer ready----------');

            Timer timer = new Timer(title: "testtitle", durationInMinutes: 2);
            _recipeHelper.insertTimer(timer);
            _recipeHelper.timers();
            Timer t = await _recipeHelper.getTimer("testtitle");
            print(t.title);
            //print(_recipeHelper.);
            //_recipeHelper.deleteRecipe("id2");
          });
          // Set default people to latest used value

        },)
      ),
      Center( child: RaisedButton(
        child: Text("recipeInstance"),
        onPressed: () {
          _recipeHelper.initializeDatabase().then((value) async{
            print('--------DB recipeInstance ready----------');
            //##########
            Ingredient ingredient = new Ingredient("name1", "measurement_unit", "type", 3.5, "picture");
            Ingredientamount ingredientAmount = new Ingredientamount(ingredient, 1.2);
            List<Ingredientamount> list;
            List<im.Step> list2;
            //var list = new List(1);
            list = new List(1);
            list2 = new List(1);
            list[0] = ingredientAmount;
            im.Step step = new im.Step(1,"a","b",1);
            list2[0] = step;
            Recipe recipe = new Recipe("id4","name",3,true,true,1,30,2,list,list2,"picture" );
            //#############""
            //await _recipeHelper.insertRecipe(recipe);
            RecipeInstance recipeInstance = new RecipeInstance(recipe, 5);
            _recipeHelper.insertRecipeInstance(recipeInstance);
            var temp =await _recipeHelper.recipeInstances();


          });

        },)

      ),
      Center( child: RaisedButton(
        child: Text("recipeInstance"),
        onPressed: () {
          _recipeHelper.initializeDatabase().then((value) async{
            print('--------DB recipeSelected ready----------');
            //##########
            Ingredient ingredient = new Ingredient("name1", "measurement_unit", "type", 3.5, "picture");
            Ingredientamount ingredientAmount = new Ingredientamount(ingredient, 1.2);
            List<Ingredientamount> list;
            List<im.Step> list2;
            //var list = new List(1);
            list = new List(1);
            list2 = new List(1);
            list[0] = ingredientAmount;
            im.Step step = new im.Step(1,"a","b",1);
            list2[0] = step;
            Recipe recipe = new Recipe("id4","name",3,true,true,1,30,2,list,list2,"picture" );
            //#############""
            await _recipeHelper.insertRecipe(recipe);
            RecipeInstance recipeInstance = new RecipeInstance(recipe, 5);
            await _recipeHelper.insertRecipeInstance(recipeInstance);
            //var recipeSelected = new RecipeSelected(recipeInstance);
            //_recipeHelper.insertRecipeSelected(recipeSelected);
            var temp =await _recipeHelper.getRecipeInstance(recipeInstance.uuid);
          });

        },)

      ),
      Center( child: RaisedButton(
        child: Text("IngredientAmountSelected"),
        onPressed: () {
          _recipeHelper.initializeDatabase().then((value) async {
            print('--------DB IngredientAmountSelected ready----------');
            Ingredient ingredient = new Ingredient("name3", "measurement_unit", "type", 3.5, "picture");
            IngredientAmountSelected ingredientAmountSelected = new IngredientAmountSelected(ingredient: ingredient,amount: 2.9,selected: false);
            _recipeHelper.insertIngredient(ingredient);
            _recipeHelper.insertIngredientAmountSelected(ingredientAmountSelected);
            List<IngredientAmountSelected> temp = await _recipeHelper.ingredientAmountSelecteds();
            print("ingredientamounselected: ");
            print(temp[0].selected);
            print(temp[0].amount);
            print(temp[0].ingredient.name);
          });
          // Set default people to latest used value

        },)
      ),
      Center( child: RaisedButton(
        child: Text("recipeSelected"),
        onPressed: () {
          _recipeHelper.initializeDatabase().then((value) async{
            print('--------DB recipeSelected ready----------');
            Ingredient ingredient = new Ingredient("name1", "measurement_unit", "type", 3.5, "picture");
            Ingredientamount ingredientAmount = new Ingredientamount(ingredient, 1.2);
            List<Ingredientamount> list;
            List<im.Step> list2;

            list = new List(1);
            list2 = new List(1);
            list[0] = ingredientAmount;
            im.Step step = new im.Step(1,"a","b",1);
            list2[0] = step;
            Recipe recipe = new Recipe("id4","name",3,true,true,1,30,2,list,list2,"picture" );
            RecipeInstance recipeInstance = new RecipeInstance(recipe, 5);
            RecipeSelected recipeSelected = new RecipeSelected(recipeInstance);

            await _recipeHelper.insertingredientAmount(ingredientAmount, recipe.id);
            await _recipeHelper.insertRecipe(recipe);
            await _recipeHelper.insertRecipeInstance(recipeInstance);
            await _recipeHelper.insertRecipeSelected(recipeSelected);
            //var temp =await _recipeHelper.getRecipeInstance(recipeInstance.uuid);

            print("recipeSelected: " + recipeSelected.recipe.uuid.toString());
            print("recipeInstance: " + recipeInstance.uuid.toString());
            var temp =await _recipeHelper.recipeSelecteds();
            print("recipeSelected: ");
            print(temp[0].uuid);
            print(temp[0].selected);
            print(temp[0].recipe.recipe.ingredients[0].ingredient.name);

          });

        },)

      ),



    ])));
    /*
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            label: 'Appetite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Buy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Cook',
          ),
        ],
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
     */


  }
}