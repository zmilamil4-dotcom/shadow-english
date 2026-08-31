import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int tabIndex = 0;
  int sentenceIndex = 0;
  bool lastAttemptSuccess = false;

  void setTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  void completeRecording() {
    lastAttemptSuccess = true;
    tabIndex = 2;
    notifyListeners();
  }

  void nextSentence(int totalSentences) {
    sentenceIndex = (sentenceIndex + 1) % totalSentences;
    lastAttemptSuccess = false;
    tabIndex = 1;
    notifyListeners();
  }

  void tryAgain() {
    lastAttemptSuccess = false;
    tabIndex = 1;
    notifyListeners();
  }
}
