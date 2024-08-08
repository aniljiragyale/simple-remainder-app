import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderPage(),
    );
  }
}

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDay;
  TimeOfDay? _selectedTime;
  String? _selectedActivity;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _onSelectNotification(String? payload) async {}

  Future<void> _initNotifications() async {
    _notificationsPlugin.initialize;
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap
  }

  Future<void> _scheduleNotification() async {
    if (_selectedTime != null) {
      final now = DateTime.now();
      final scheduledDate = DateTime(now.year, now.month, now.day,
          _selectedTime!.hour, _selectedTime!.minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate.add(Duration(days: 1));
      }
      await _notificationsPlugin.schedule(
        0,
        'Reminder',
        'It\'s time for $_selectedActivity!',
        scheduledDate,
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Day of the week',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDay,
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value;
                  });
                },
                items: [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday',
                ].map((day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Time: '),
                  SizedBox(width: 10),
                  ElevatedButton(
                    child: Text(_selectedTime == null
                        ? 'Select time'
                        : _selectedTime!.format(context)),
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        setState(() {
                          _selectedTime = time;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Activity',
                  border: OutlineInputBorder(),
                ),
                value: _selectedActivity,
                onChanged: (value) {
                  setState(() {
                    _selectedActivity = value;
                  });
                },
                items: [
                  'Wake up',
                  'Go to gym',
                  'Breakfast',
                  'Meetings',
                  'Lunch',
                  'Quick nap',
                  'Go to library',
                  'Dinner',
                  'Go to sleep',
                ].map((activity) {
                  return DropdownMenuItem<String>(
                    value: activity,
                    child: Text(activity),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Set Reminder'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Schedule notification
                    _scheduleNotification();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on FlutterLocalNotificationsPlugin {
  schedule(int i, String s, String t, DateTime scheduledDate,
      {required AndroidNotificationDetails android}) {}
}
