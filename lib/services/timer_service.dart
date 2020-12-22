import 'dart:collection';
import 'package:abc_cooking/models/timer.dart';
import 'package:flutter/material.dart';

class MyTimersService extends ChangeNotifier {
  static final MyTimersService _singleton = MyTimersService._internal();
  List<Timer> _myTimers = [];

  factory MyTimersService() {
    return _singleton;
  }

  MyTimersService._internal() {
    // TODO Load timers from database
  }

  void saveCart() async {
    // TODO save timers to database
  }

  List<Timer> get myTimers => _myTimers;

  void addTimer(Timer timer) {
    _myTimers.add(timer);
    notifyListeners();
  }

  void removeTimerAt(int i) {
    _myTimers.removeAt(i);
    notifyListeners();
  }

  void removeTimer(Timer timer) {
    _myTimers.remove(timer);
    notifyListeners();
  }
}