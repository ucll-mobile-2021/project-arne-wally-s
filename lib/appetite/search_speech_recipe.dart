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
  final SpeechToText speech = SpeechToText();
  bool listening = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "en";
  Map<String, dynamic> response = Map();
  Future<List<Recipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  @override
  Widget build(BuildContext context) {
    String responseText = response.isNotEmpty ? response['response'] : '';
    List<TextSpan> myText = List();
    TextStyle style = TextStyle(fontSize: 18);
    if (response.isNotEmpty) {
      var lastIndex = 0;
      for (var food in response['food']) {
        var startIndex = food['location'][0];
        var endIndex = food['location'][1];

        myText.add(TextSpan(
          text: lastWords.substring(lastIndex, startIndex),
          style: style.merge(TextStyle(color: Colors.black)),
        ));
        myText.add(TextSpan(
          text: lastWords.substring(startIndex, endIndex),
          style: style.merge(TextStyle(color: Colors.deepOrange)),
        ));

        lastIndex = endIndex;
      }
      myText.add(TextSpan(
        text: lastWords.substring(lastIndex),
        style: style.merge(TextStyle(color: Colors.black)),
      ));
    } else {
      myText.add(TextSpan(
        text: lastWords,
        style: style.merge(TextStyle(color: Colors.black)),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipe'),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                listening ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                      child: Text(
                        'Listening...',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      )),
                ) : SizedBox(),
                lastWords == '' && !listening
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                            child: Text(
                          'Tap to start speaking',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )),
                      )
                    : SizedBox(),
                lastWords == ''
                    ? SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(
                            right: 80, left: 10, bottom: 10, top: 10),
                        child: RichText(
                          text: TextSpan(children: myText),
                        ),
                      ),
                responseText == ''
                    ? SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrange,
                        ),
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(
                            left: 80, right: 10, bottom: 10),
                        child: Text(
                          responseText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
              ],
            ),
            responseText == '' || futureRecipes == null
                ? SizedBox()
                : SelectRecipeWidget(futureRecipes),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: toggleListening,
      ),
    );
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);

    if (!mounted) return;
  }

  void toggleListening() {
    if (!listening) {
      startListening();
    } else {
      stopListening();
    }
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    response = Map();
    speech.listen(
        onResult: resultListener,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {
      listening = true;
    });
  }

  void listeningEnded() {
    setState(() {
      listening = false;
    });
  }

  void stopListening() {
    speech.stop();
    listeningEnded();
  }

  void cancelListening() {
    speech.cancel();
    listeningEnded();
  }

  Future sleep() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }

  void resultListener(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
    if (result.finalResult) {
      listeningEnded();
      var r = await AppetiteService().watsonCall(result.recognizedWords);
      setState(() {
        response = r;
      });

      if (response['food'].isNotEmpty) {
        List<String> foods = [];
        for (var food in response['food']) {
          foods.add(food['value']);
        }
        setState(() {
          futureRecipes = AppetiteService().getSearchFoodListResultsRecipes(foods);
        });
      }
    }
  }

  void soundLevelListener(double level) {
    // Could maybe create wave animation from this
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }
}
