import 'dart:ui';
import 'package:flutter/material.dart';

class AlarmInfo {
  DateTime alarmDateTime;
  String? description;
  bool isActive;
  List<Color>? gradientColors;
  List<bool> repeatDays; // [sun, mon, tue, wed, thu, fri, sat]
  bool isVibrate;
  String? soundPath;

  AlarmInfo(
      this.alarmDateTime, {
        this.description,
        this.gradientColors,
        this.isActive = true,
        this.repeatDays = const [false, false, false, false, false, false, false],
        this.isVibrate = true,
        this.soundPath,
      });

  String getDayText() {
    if (repeatDays.every((day) => day == false)) return 'Once';
    if (repeatDays.every((day) => day == true)) return 'Daily';

    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<String> activeDays = [];
    for (int i = 0; i < repeatDays.length; i++) {
      if (repeatDays[i]) activeDays.add(days[i]);
    }
    return activeDays.join(', ');
  }
}