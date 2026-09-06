import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int tabIndex = 0; // 0 Home, 1 Learn, 2 Practice, 3 Progress, 4 Profile
  int sentenceIndex = 0;
  int totalTrained = 0;
  int streakDays = 1;

  void setTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  void goToPractice() {
    tabIndex = 2;
    notifyListeners();
  }

  void nextSentence(int totalSentences) {
    sentenceIndex = (sentenceIndex + 1) % totalSentences;
    notifyListeners();
  }

  void previousSentence(int totalSentences) {
    sentenceIndex = (sentenceIndex - 1 + totalSentences) % totalSentences;
    notifyListeners();
  }

  void recordCompleted() {
    totalTrained++;
    notifyListeners();
  }
}
