import 'dart:async';

import 'package:abc_cooking/cook/cook_page.dart';
import 'package:abc_cooking/buy/buy_page.dart';
import 'package:abc_cooking/appetite/appetite_page.dart';
import 'package:abc_cooking/models/cart.dart';
import 'package:abc_cooking/models/ingredient_amount.dart';
import 'package:abc_cooking/models/timer.dart' as timerData;
import 'package:abc_cooking/services/service.dart';
import 'package:abc_cooking/services/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abc_cooking/models/step.dart' as im;
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'DB/DB.dart';
import 'models/ingredient.dart';
import 'models/recipe.dart';

void main() => runApp(MyApp());

// TODO Splashscreen for the app

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyRecipesService()),
        ChangeNotifierProvider(create: (_) => MyTimersService()),
      ],
      child: MaterialApp(
        title: 'ABC Cooking',
        navigatorKey: navigatorKey,
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
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  RecipeHelper _recipeHelper= RecipeHelper();
  static final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  static List<Widget> _pages = <Widget>[
    AppetiteWidget(),
    BuyWidget(),
    CookWidget(),
  ];

  final controller = PageController(initialPage: 0, keepPage: true);

  void _setIndex(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Timer _countingTimer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _countingTimer.cancel();
    super.dispose();
  }

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("microwave.mp3");
  }

  void _startTimer() {
    _countingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      var timerService = MyTimersService();
      if (timerService.myTimers.length > 0) {
        var timers = List.from(timerService.myTimers).map((e) => e).toList();
        for (var timer in timers) {
          if (timer.timeLeftInSeconds() <= 0) {
            Vibration.vibrate();
            playLocalAsset();
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Time!'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('${timer.title} is done!'),
                        Text('Be sure to check your food before continuing.'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Got it!'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
            timerService.removeTimer(timer);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var pageView = PageView(children: _pages, onPageChanged: _setIndex,);
    //button
    return Scaffold(
      key: scaffoldKey,
      body: pageView,
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            pageView.controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
          } ,
      ),
    );
  }
}