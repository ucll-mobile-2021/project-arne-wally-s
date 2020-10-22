import 'package:abc_cooking/appetite/select_recipe.dart';
import 'package:abc_cooking/models/recipe.dart';
import 'package:abc_cooking/services/appetite_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';

class SearchRecipeSpeechWidget extends StatefulWidget {
  @override
  _SearchRecipeSpeechState createState() {
    return _SearchRecipeSpeechState();
  }
}

class _SearchRecipeSpeechState extends State<SearchRecipeSpeechWidget> {
  final SpeechToText _speech = SpeechToText();
  String _currentLocaleId = "en";

  SpeechState _state = SpeechState.init;

  String _spokenWords = "";

  String _responseWords = "";
  List<Map<String, dynamic>> _foodRecognized = [];

  Future<List<Recipe>> _futureSearchResults;

  TextStyle _textStyle = TextStyle(fontSize: 18);

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (_state) {
      case SpeechState.init:
        body = Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Tap to start speaking',
            style: _textStyle,
          ),
        ));
        break;
      case SpeechState.listening:
        body = buildListeningWidget(context);
        break;
      case SpeechState.finishedListening:
        body = buildFinishedListeningWidget(context);
        break;
      case SpeechState.watsonResponded:
        body = buildWatsonResponded(context);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipe'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: _state == SpeechState.listening ? 30 : 0,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Listening...'),
              )),
            ),
            body,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: toggleListening,
      ),
    );
  }

  Widget buildListeningWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _spokenWords == '' // Don't show dialogue if nothing said yet
            ? SizedBox()
            : buildMyText(context, [
                TextSpan(
                  text: _spokenWords,
                  style: _textStyle.merge(TextStyle(color: Colors.black)),
                )
              ])
      ],
    );
  }

  Widget buildFinishedListeningWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildMyText(context, [
          TextSpan(
            text: _spokenWords,
            style: _textStyle.merge(TextStyle(color: Colors.black)),
          )
        ]),
        buildResponseText(
            context,
            Text(
              '...',
              style: _textStyle.merge(TextStyle(color: Colors.white)),
            ))
      ],
    );
  }

  Widget buildWatsonResponded(BuildContext context) {
    List<TextSpan> myText = List();
    if (_responseWords != '') {
      var lastIndex = 0;
      for (var food in _foodRecognized) {
        var startIndex = food['location'][0];
        var endIndex = food['location'][1];

        myText.add(TextSpan(
          text: _spokenWords.substring(lastIndex, startIndex),
          style: _textStyle.merge(TextStyle(color: Colors.black)),
        ));
        myText.add(TextSpan(
          text: _spokenWords.substring(startIndex, endIndex),
          style: _textStyle.merge(TextStyle(color: Colors.deepOrange)),
        ));

        lastIndex = endIndex;
      }
      myText.add(TextSpan(
        text: _spokenWords.substring(lastIndex),
        style: _textStyle.merge(TextStyle(color: Colors.black)),
      ));
    } else {
      myText.add(TextSpan(
        text: _spokenWords,
        style: _textStyle.merge(TextStyle(color: Colors.black)),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildMyText(context, myText),
        buildResponseText(
            context,
            Text(
              _responseWords,
              style: _textStyle.merge(TextStyle(color: Colors.white)),
            )),
        _foodRecognized.isEmpty
            ? SizedBox()
            : SelectRecipeWidget(_futureSearchResults),
      ],
    );
  }

  Widget buildMyText(BuildContext context, List<TextSpan> myWords) {
    /*
    This takes a List of TextSpans so that we can pass differently coloured words
     */
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 80, left: 10, bottom: 10, top: 10),
      child: RichText(
        text: TextSpan(children: myWords),
      ),
    );
  }

  Widget buildResponseText(BuildContext context, Widget responseWidget) {
    /*
    This takes a widget so that we can pass a typing animation
    */
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepOrange,
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 80, right: 10, bottom: 10),
      child: responseWidget,
    );
  }

  Future<void> initSpeechState() async {
    await _speech.initialize(onError: errorListener);

    if (!mounted) return;
  }

  void toggleListening() {
    if (_state != SpeechState.listening) {
      startListening();
    } else {
      stopListening();
    }
  }

  void startListening() {
    _speech.listen(
        onResult: resultListener,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);

    setState(() {
      _state = SpeechState.listening;
      _spokenWords = "";
    });
  }

  void stopListening() {
    _speech.stop();
    setState(() {
      _state = SpeechState.init;
      _spokenWords = "";
    });
  }

  void resultListener(SpeechRecognitionResult result) async {
    setState(() {
      _spokenWords = result.recognizedWords;
    });

    if (result.finalResult) {
      setState(() {
        _state = SpeechState.finishedListening;
      });

      var r = await AppetiteService().watsonCall(result.recognizedWords);

      setState(() {
        _state = SpeechState.watsonResponded;
      });

      _responseWords = r['response'];
      _foodRecognized = List<Map<String, dynamic>>.from(r['food']);

      if (_foodRecognized.isNotEmpty) {
        List<String> foods = [];
        for (var food in _foodRecognized) {
          foods.add(food['value']);
        }

        setState(() {
          _futureSearchResults =
              AppetiteService().getSearchFoodListResultsRecipes(foods);
        });
      }
    }
  }

  void soundLevelListener(double level) {
    // Could maybe create wave animation from this
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
  }
}

enum SpeechState {
  init,
  listening,
  finishedListening,
  watsonResponded,
}
