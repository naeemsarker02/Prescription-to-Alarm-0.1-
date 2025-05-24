import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prescription_to_alarm/models/alarm_info.dart';
import 'package:prescription_to_alarm/Utils/data.dart';

import '../constants/theme_data.dart';
import 'add_alarm_screen.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alarm',
              style: TextStyle(
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 24),
            ),
            Expanded(
              child: ListView(
                children: alarms.map((alarm) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 32),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: alarm.gradientColors ??
                            [Colors.purple, Colors.red],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(4, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.label,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(alarm.description ?? 'Alarm',
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: 'avenir'),
                                ),
                              ],
                            ),
                            Switch(
                              onChanged: (bool value) {
                                setState(() {
                                  alarm.isActive = value;
                                });
                              },
                              value: alarm.isActive,
                              activeColor: Colors.white,
                            ),
                          ],
                        ),
                        Text(alarm.getDayText(),
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'avenir'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('h:mm a').format(alarm.alarmDateTime),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'avenir',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white),
                              onPressed: () => _editAlarm(alarm),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addAlarm() async {
    final alarm = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAlarmScreen()),
    );
    if (alarm != null) {
      setState(() {
        alarms.add(alarm);
      });
    }
  }

  void _editAlarm(AlarmInfo alarm) async {
    final updatedAlarm = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAlarmScreen(alarm: alarm)),
    );
    if (updatedAlarm != null) {
      setState(() {
        final index = alarms.indexOf(alarm);
        alarms[index] = updatedAlarm;
      });
    }
  }
}