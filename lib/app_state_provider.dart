import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int tabIndex = 0; // 0 Home, 1 Learn, 2 Practice, 3 Progress, 4 Profile
  int sentenceIndex = 0;
  int totalTrained = 0;
  int streakDays = 1;

  // Compatibility field for the legacy ResultsTab (not wired into the
  // current bottom navigation, but still present in the project).
  bool lastAttemptSuccess = false;

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
    lastAttemptSuccess = false;
    notifyListeners();
  }

  void previousSentence(int totalSentences) {
    sentenceIndex = (sentenceIndex - 1 + totalSentences) % totalSentences;
    notifyListeners();
  }

  void recordCompleted() {
    totalTrained++;
    lastAttemptSuccess = true;
    notifyListeners();
  }

  // Compatibility method for the legacy ResultsTab.
  void tryAgain() {
    lastAttemptSuccess = false;
    notifyListeners();
  }
}
