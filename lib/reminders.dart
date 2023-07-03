import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Reminder {
  final String title;
  final String frequency;
  bool isActive;

  Reminder({
    required this.title,
    required this.frequency,
    this.isActive = true,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      title: json['title'],
      frequency: json['frequency'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'frequency': frequency,
      'isActive': isActive,
    };
  }
}

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Reminder> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? remindersJson = prefs.getStringList('reminders');
    if (remindersJson != null) {
      setState(() {
        reminders = remindersJson
            .map((item) => Reminder.fromJson(json.decode(item)))
            .toList();
      });
    }
  }

  void _saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> remindersJson =
        reminders.map((reminder) => json.encode(reminder.toJson())).toList();
    await prefs.setStringList('reminders', remindersJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          Reminder reminder = reminders[index];
          return Dismissible(
            key: Key(reminder.title),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                reminders.removeAt(index);
              });
              _saveReminders();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                color: Colors.grey[900],
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text(
                    reminder.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    reminder.frequency,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        reminder.isActive = !reminder.isActive;
                      });
                      _saveReminders();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        reminder.isActive
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  onTap: () {
                    _navigateToAddReminderScreen(
                        reminder: reminder, index: index);
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddReminderScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddReminderScreen({Reminder? reminder, int? index}) async {
    Reminder? newReminder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderScreen(reminder: reminder),
      ),
    );
    if (newReminder != null) {
      setState(() {
        if (index != null) {
          reminders[index] = newReminder;
        } else {
          reminders.add(newReminder);
        }
      });
      _saveReminders();
    }
  }
}

class AddReminderScreen extends StatefulWidget {
  final Reminder? reminder;

  AddReminderScreen({Key? key, this.reminder}) : super(key: key);

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  late TextEditingController _titleController;
  late TextEditingController _frequencyController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.reminder?.title ?? '');
    _frequencyController =
        TextEditingController(text: widget.reminder?.frequency ?? '');
    _isActive = widget.reminder?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder != null ? 'Edit Reminder' : 'Add Reminder'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16.0),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _frequencyController,
              decoration: InputDecoration(
                  labelText: 'Frequency',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16.0),
            CheckboxListTile(
              title: Text('Active', style: TextStyle(color: Colors.white)),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveReminder();
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _saveReminder() {
    String title = _titleController.text.trim();
    String frequency = _frequencyController.text.trim();

    if (title.isNotEmpty && frequency.isNotEmpty) {
      Reminder reminder = Reminder(
        title: title,
        frequency: frequency,
        isActive: _isActive,
      );

      Navigator.pop(context, reminder);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error', style: TextStyle(color: Colors.white)),
            content:
                Text('Please enter a title and frequency for the reminder.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
