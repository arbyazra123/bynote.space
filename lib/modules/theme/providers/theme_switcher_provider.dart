import 'package:flutter/material.dart';
import 'package:web_todolist/shared/theme.dart';

class ThemeSwitcherProvider extends ChangeNotifier {
  String currentAnimation = "night_idle";
  bool loading=false;
  CustomTheme theme = NightTheme();
  void changeFlareAnimation(String v) {
    currentAnimation = v;
    notifyListeners();
  }

  void toggleTheme(bool isNight) {
    if (isNight) {
      this.theme = DayTheme(isNight: false);
    } else {
      this.theme = NightTheme(isNight: true);
    }
    notifyListeners();
  }

  void isLoading(bool loading) {
    this.loading = loading;
    notifyListeners();
  }
}
