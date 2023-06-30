import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puckjs_app/one_tap.dart';
import 'mongodb.dart';
import 'dart:io';


class SelectContactPage extends StatefulWidget {
  final String filePath;

  const SelectContactPage({Key? key, required this.filePath}) : super(key: key);

  @override
  SelectContactState createState() => SelectContactState();
}

class SelectContactState extends State<SelectContactPage> {
  String? selectedContactId; // Define the selectedContactId variable
  late BuildContext pageContext; // Store the context in a variable

  Future<String> getPhoneNumber(String contactId) async {
    // Make a call to the database or any other method to retrieve the phoneNumber
    // based on the contactId and return it
    // Replace this with your actual implementation

    // Assuming you have a method to fetch the contact details by ID from the database
    final contact = await MongoDatabase.fetchContactById(contactId);
    final phoneNumber = contact['phone_number'].toString();
    return phoneNumber;
  }

  void savePhoneNumberToFile(String phoneNumber) async {
    final file = File(widget.filePath);
    await file.writeAsString(phoneNumber);
    print('PhoneNumber saved: $phoneNumber');
  }

  @override
  Widget build(BuildContext context) {
    pageContext = context; // Store the context in the variable

      return Scaffold(
        backgroundColor: const Color(0xFF211F26),
        appBar: AppBar(
          backgroundColor: const Color(0xFF211F26),
          title: const Text(
            'Select your emergency contact',
            style: TextStyle(color: Color(0xffCAC4D0)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: MongoDatabase.getContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching contacts'));
            } else if (snapshot.hasData) {
              final contacts = snapshot.data!;
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  final contactId = contact['_id'].toString(); // Convert ObjectId to String
                  final firstName = contact['first_name'] ?? '';
                  final lastName = contact['last_name'] ?? '';
                  final fullName = '$firstName $lastName';
                  final firstLetter = firstName.isNotEmpty ? firstName[0] : '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF2C3D7A),
                      child: Text(
                        firstLetter.toUpperCase(),
                        style: TextStyle(fontSize: 16.sp, color: const Color(0xFFEADDFF)),
                      ),
                    ),
                    title: Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color:const Color(0xffCAC4D0),
                      ),
                    ),
                    trailing: Radio<String>(
                      value: contactId,
                      groupValue: selectedContactId,
                      onChanged: (value) {
                        setState(() {
                          selectedContactId = value;
                        });
                      },
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        floatingActionButton: Builder(
          builder: (BuildContext scaffoldContext) => FloatingActionButton(
          onPressed: () async {
            // Perform the necessary actions with the selected contact ID
            if (selectedContactId != null) {
              // The selectedContactId variable holds the ID of the selected contact
              // Perform the desired actions with the selected contact
              // For example, save the selected contact ID or navigate to another page
              final phoneNumber = await getPhoneNumber(selectedContactId!);
              savePhoneNumberToFile(phoneNumber);
            
              if (context.mounted){
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => const Onetap(),
                )
                );
              }
            } else {
            
              if (context.mounted){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => const Onetap(),
                )
              );
            }
              // Handle the case where no contact is selected
              // Display an error message or prevent further actions
            }
          },
          child: const Icon(Icons.check, color:Color(0xFF2C3D7A)),
        ),
      ),
    );
  }
}
