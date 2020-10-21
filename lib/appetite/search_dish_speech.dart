import 'package:abc_cooking/models/dish.dart';
import 'package:abc_cooking/services/add_dish_service.dart';
import 'package:abc_cooking/widgets/dish.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';
import 'dart:io';

class SearchDishSpeechWidget extends StatefulWidget {
  @override
  _SearchDishSpeechWidget createState() {
    return _SearchDishSpeechWidget();
  }
}

class _SearchDishSpeechWidget extends State<SearchDishSpeechWidget> {
  final SpeechToText speech = SpeechToText();
  bool listening = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "en";
  Map<String, dynamic> response = Map();

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  @override
  Widget build(BuildContext context) {
    String responseText = response.isNotEmpty ? response['response'] : '';
    List<TextSpan> myText = List();
    TextStyle style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
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
      if (response['food'].isNotEmpty) {
        myText.add(TextSpan(
          text: lastWords.substring(lastIndex),
          style: style.merge(TextStyle(color: Colors.black)),
        ));
      }
    } else {
      myText.add(TextSpan(
        text: lastWords,
        style: style.merge(TextStyle(color: Colors.black)),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Search dish'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: responseText == ''
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrange,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            responseText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                RichText(
                  text: TextSpan(children: myText),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                    width: 90.0,
                    height: 90.0,
                    child: new RawMaterialButton(
                      shape: new CircleBorder(),
                      elevation: 0.0,
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: toggleListening,
                      fillColor: Theme.of(context).accentColor,
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(listening ? 'Listening' : ''),
                ),
              ],
            ),
          ],
        ),
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
    return new Future.delayed(const Duration(seconds: 3), () => "1");
  }

  void resultListener(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
    if (result.finalResult) {
      listeningEnded();
      var r = await AddDishService().watsonCall(result.recognizedWords);
      setState(() {
        response = r;
      });

      if (response['food'].isNotEmpty) {
        List<String> foods = response['food'].map((e) => e['value'] as String).toList();
        var dishResults = AddDishService().getDishResultsFromFoodList(
            foods);
        await sleep();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DishSelect(dishResults);
        }));
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

class ReturnTypeSpeechSearch {
  final Dish dish;
  final int people;

  ReturnTypeSpeechSearch(this.dish, this.people);
}

class DishSelect extends StatelessWidget {
  final Future<List<Dish>> futureResults;

  DishSelect(this.futureResults);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return DishWidget.tap(snapshot.data[index], () {
                    Navigator.pop(context, snapshot.data[index]);
                  });
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
