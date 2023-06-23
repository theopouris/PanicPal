import 'package:flutter/material.dart';
import 'editrems.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Reminder> reminders = [
    Reminder(title: 'Reminder 1', frequency: 'Daily', isActive: true),
    Reminder(title: 'Reminder 2', frequency: 'Weekly', isActive: false),
    Reminder(title: 'Reminder 3', frequency: 'Monthly', isActive: true),
  ];

  void toggleReminder(int index) {
    setState(() {
      reminders[index].isActive = !reminders[index].isActive;
    });
  }

  void editReminder(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReminderScreen(
          reminderTitle: reminders[index].title,
          reminderFrequency: reminders[index].frequency,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        reminders[index].title = result['title'];
        reminders[index].frequency = result['frequency'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ListTile(
            tileColor:
                reminder.isActive ? const Color(0xFF1D1A22) : Colors.grey[400],
            title: Text(
              reminder.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              reminder.frequency,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => toggleReminder(index),
                  icon: Icon(
                    reminder.isActive ? Icons.toggle_on : Icons.toggle_off,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => editReminder(index),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add reminder functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Reminder {
  String title;
  String frequency;
  bool isActive;

  Reminder({
    required this.title,
    required this.frequency,
    required this.isActive,
  });
}
