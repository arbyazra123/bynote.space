

import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier{
  var currentDate = DateTime.now();

  void changeDate(changedDate){
   this.currentDate =  changedDate;
   notifyListeners();
  }
}