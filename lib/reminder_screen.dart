import 'package:flutter/material.dart';
import 'notification_service.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController reminderTextController = TextEditingController();
  bool isDailyTask = false;
  bool isWeeklyTask = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: reminderTextController,
              decoration: InputDecoration(
                hintText: 'Enter your reminder...',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      print('Selected Date: $selectedDate');
                    }
                  },
                  child: Text('Select Date'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      print('Selected Time: $selectedTime');
                    }
                  },
                  child: Text('Select Time'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Checkbox(
                  value: isDailyTask,
                  onChanged: (value) {
                    setState(() {
                      isDailyTask = value!;
                      if (isDailyTask) {
                        isWeeklyTask = false; // Uncheck weekly if daily is checked
                      }
                    });
                  },
                ),
                Text('Daily'),
                Checkbox(
                  value: isWeeklyTask,
                  onChanged: (value) {
                    setState(() {
                      isWeeklyTask = value!;
                      if (isWeeklyTask) {
                        isDailyTask = false; // Uncheck daily if weekly is checked
                      }
                    });
                  },
                ),
                Text('Weekly'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                createNotification();
              },
              child: Text('Set a reminder'),
            ),
          ],
        ),
      ),
    );
  }

  void createNotification() {
    DateTime now = DateTime.now();
    DateTime nextDay = DateTime(now.year, now.month, now.day + 1);

    if (selectedDate == null) {
      selectedDate = nextDay;
      print('Selected Date: $selectedDate (defaulted to next day)');
    }

    if (selectedTime == null) {
      selectedTime = TimeOfDay.now();
      print('Selected Time: $selectedTime (defaulted to current time)');
    }

    String reminderText =
    reminderTextController.text.isEmpty ? 'Reminder' : reminderTextController.text;

    DateTime scheduledDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    NotificationService.showScheduledNotification(
      scheduledDate: scheduledDateTime,
      title: 'Reminder',  //title and body of the notification can be changed here
      body: reminderText,
      payload: 'your_payload',
      isDailyTask: isDailyTask,
      isWeeklyTask: isWeeklyTask,
    );

  }
}

void main() {
  NotificationService.initialize(); // Initialize the NotificationService
  runApp(MaterialApp(
    home: ReminderScreen(),
  ));
}
