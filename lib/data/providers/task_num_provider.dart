import 'package:flutter/material.dart';

class TaskNumProvider extends ChangeNotifier {
  int _taskNum = 0;
  int get taskNum => _taskNum;

  setTaskNum(int value) {
    _taskNum = value;
    notifyListeners();
  }

  increaseTaskNum() {
    _taskNum++;
    notifyListeners();
  }

  decreaseTaskNum() {
    if (_taskNum > 1) {
      _taskNum--;
    }
    notifyListeners();
  }
}
