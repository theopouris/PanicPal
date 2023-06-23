import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Reminder {
  final String title;
  final String frequency;
  final bool isRecurring;
  final DateTime? date;
  final TimeOfDay? time;
  final List<bool>? days;

  Reminder({
    required this.title,
    required this.frequency,
    this.isRecurring = false,
    this.date,
    this.time,
    this.days,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    required List<bool> selectedDays,
  });
}

class EditReminderScreen extends StatefulWidget {
  final Reminder reminder;

  const EditReminderScreen({Key? key, required this.reminder})
      : super(key: key);

  @override
  _EditReminderScreenState createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  late String selectedFrequency;
  late bool isRecurring;
  late DateTime? selectedDate;
  late TimeOfDay? selectedTime;
  late List<bool> selectedDays;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.reminder.title;
    selectedFrequency = widget.reminder.frequency;
    isRecurring = widget.reminder.isRecurring;
    selectedDate = widget.reminder.date ?? DateTime.now();
    selectedTime = widget.reminder.time ?? TimeOfDay.now();
    selectedDays = widget.reminder.days ?? List.generate(7, (index) => false);
  }

  void saveChanges() {
    final updatedReminder = Reminder(
      title: _titleController.text,
      frequency: selectedFrequency,
      isRecurring: isRecurring,
      date: selectedDate,
      time: selectedTime,
      days: selectedDays,
      selectedDays: selectedDays, // Pass selectedDays to the constructor
    );

    Navigator.pop(context, updatedReminder);
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void toggleDay(int index) {
    setState(() {
      selectedDays[index] = !selectedDays[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reminder Title',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter title',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Frequency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedFrequency,
                dropdownColor: const Color(0xFF1D1A22),
                onChanged: (newValue) {
                  setState(() {
                    selectedFrequency = newValue!;
                    isRecurring = selectedFrequency != 'Single Day';
                  });
                },
                items: <String>['Single Day', 'Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              if (isRecurring)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Days of the Week',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      children: List.generate(7, (index) {
                        final day = index + 1;
                        final dayName = DateFormat('EEEE').format(DateTime.now()
                            .add(Duration(days: day - DateTime.now().weekday)));
                        return InkWell(
                          onTap: () => toggleDay(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedDays[index]
                                  ? const Color(0xFF1D1A22)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedDays[index]
                                    ? Colors.transparent
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  dayName,
                                  style: TextStyle(
                                    color: selectedDays[index]
                                        ? Colors.white
                                        : Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.check,
                                  color: selectedDays[index]
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              const Text(
                'Date and Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Select Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          '${selectedDate?.toLocal() ?? DateTime.now().toLocal()}'
                              .split(' ')[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: selectTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Select Time',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          selectedTime?.format(context) ??
                              TimeOfDay.now().format(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveChanges,
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AddReminderScreen extends StatefulWidget {
  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  late String selectedFrequency;
  late bool isRecurring;
  late DateTime? selectedDate;
  late TimeOfDay? selectedTime;
  late List<bool> selectedDays;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedFrequency = 'Single Day';
    isRecurring = false;
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    selectedDays = List.generate(7, (index) => false);
  }

  void saveReminder() {
    final newReminder = Reminder(
      title: _titleController.text,
      frequency: selectedFrequency,
      isRecurring: isRecurring,
      date: selectedDate,
      time: selectedTime,
      days: selectedDays,
      selectedDays: selectedDays, // Pass selectedDays to the constructor
    );

    Navigator.pop(context, newReminder);
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void toggleDay(int index) {
    setState(() {
      selectedDays[index] = !selectedDays[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reminder Title',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter title',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Frequency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedFrequency,
                dropdownColor: const Color(0xFF1D1A22),
                onChanged: (newValue) {
                  setState(() {
                    selectedFrequency = newValue!;
                    isRecurring = selectedFrequency != 'Single Day';
                  });
                },
                items: <String>['Single Day', 'Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              if (isRecurring)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Days of the Week',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      children: List.generate(7, (index) {
                        final day = index + 1;
                        final dayName = DateFormat('EEEE').format(DateTime.now()
                            .add(Duration(days: day - DateTime.now().weekday)));
                        return InkWell(
                          onTap: () => toggleDay(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedDays[index]
                                  ? const Color(0xFF1D1A22)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedDays[index]
                                    ? Colors.transparent
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  dayName,
                                  style: TextStyle(
                                    color: selectedDays[index]
                                        ? Colors.white
                                        : Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.check,
                                  color: selectedDays[index]
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              const Text(
                'Date and Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Select Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          '${selectedDate?.toLocal() ?? DateTime.now().toLocal()}'
                              .split(' ')[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: selectTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Select Time',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          selectedTime?.format(context) ??
                              TimeOfDay.now().format(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveReminder,
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ReminderScreen extends StatefulWidget {
  final List<Reminder> reminders;

  const ReminderScreen({Key? key, required this.reminders}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<Reminder> _userReminders = [];

  @override
  void initState() {
    super.initState();
    _userReminders = widget.reminders;
  }

  Future<void> navigateToAddReminder() async {
    final newReminder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderScreen(),
      ),
    );

    if (newReminder != null) {
      setState(() {
        _userReminders.add(newReminder as Reminder);
      });
    }
  }

  Future<void> navigateToEditReminder(Reminder reminder) async {
    final updatedReminder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReminderScreen(reminder: reminder),
      ),
    );

    if (updatedReminder != null) {
      setState(() {
        final index = _userReminders.indexOf(reminder);
        _userReminders[index] = updatedReminder as Reminder;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reminders'),
      ),
      body: ListView.builder(
        itemCount: _userReminders.length,
        itemBuilder: (context, index) {
          final reminder = _userReminders[index];
          return ListTile(
            title: Text(reminder.title),
            subtitle: Text(reminder.frequency),
            onTap: () => navigateToEditReminder(reminder),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
