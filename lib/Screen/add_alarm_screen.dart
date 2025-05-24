import 'package:flutter/material.dart';
import 'package:prescription_to_alarm/models/alarm_info.dart';
import 'package:prescription_to_alarm/constants/theme_data.dart';

class AddAlarmScreen extends StatefulWidget {
  final AlarmInfo? alarm;
  const AddAlarmScreen({Key? key, this.alarm}) : super(key: key);

  @override
  _AddAlarmScreenState createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  late TimeOfDay _selectedTime;
  late List<bool> _repeatDays;
  late bool _isActive;
  late bool _isVibrate;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.alarm?.alarmDateTime != null
        ? TimeOfDay.fromDateTime(widget.alarm!.alarmDateTime)
        : TimeOfDay.now();
    _repeatDays = widget.alarm?.repeatDays ??
        [false, false, false, false, false, false, false];
    _isActive = widget.alarm?.isActive ?? true;
    _isVibrate = widget.alarm?.isVibrate ?? true;
    _descriptionController =
        TextEditingController(text: widget.alarm?.description ?? 'Medicine');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      appBar: AppBar(
        title: Text(widget.alarm == null ? 'Add Alarm' : 'Edit Alarm'),
        backgroundColor: CustomColors.menuBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Time Picker
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) {
                  setState(() => _selectedTime = time);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  _selectedTime.format(context),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),

            // Repeat Days
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Repeat',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _repeatDays[index] = !_repeatDays[index];
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: _repeatDays[index]
                              ? Colors.blue
                              : Colors.grey[800],
                          child: Text(
                            days[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Vibration Switch
            SwitchListTile(
              title: Text('Vibration', style: TextStyle(color: Colors.white)),
              value: _isVibrate,
              onChanged: (value) => setState(() => _isVibrate = value),
              activeColor: Colors.blue,
            ),

            // Sound Selection (Simplified)
            ListTile(
              title: Text('Alarm Sound', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.volume_up, color: Colors.white),
              onTap: () {
                // You can implement sound selection here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Default alarm sound will be used')),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAlarm,
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _saveAlarm() {
    final alarmDateTime = DateTime(
      DateTime
          .now()
          .year,
      DateTime
          .now()
          .month,
      DateTime
          .now()
          .day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final alarm = AlarmInfo(
      alarmDateTime,
      description: _descriptionController.text,
      repeatDays: _repeatDays,
      isActive: _isActive,
      isVibrate: _isVibrate,
      gradientColors: GradientTemplate.gradientTemplate[
      DateTime
          .now()
          .second % GradientTemplate.gradientTemplate.length].colors,
    );

    Navigator.pop(context, alarm);
  }
}