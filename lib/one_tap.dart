import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:puckjs_app/add_text.dart';
import 'package:puckjs_app/settings.dart';
import 'select_contact_2.dart';

  bool sendAutomatedMessage = false;
  bool callSpecificContact = false;
  bool callEmergencyServices = false;
  String emergency_services = '112';

class Onetap extends StatefulWidget {
  const Onetap({Key? key}) : super(key: key);

  @override
  OnetapState createState() => OnetapState();
}

class OnetapState extends State<Onetap> {
  Future<void> createFile(String filePath) async {
    final file = File(filePath);
    await file.create();
  }

  Future<File> writeToFile(String text, String filePath) async {
    final file = File(filePath);
    return file.writeAsString(text);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F26),
      appBar: AppBar(
        backgroundColor: const Color(0xFF211F26),
        title: const Text(
          'Single Tap',
          style: TextStyle(color: Color.fromARGB(255, 230, 224, 233)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            // Handle going to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Switch(
                  activeColor: const Color(0xff6750A4),
                  activeTrackColor: const Color(0xffD0BCFF),
                  inactiveThumbColor: const Color(0xff938F99),
                  inactiveTrackColor: const Color(0xff36343B),
                  splashRadius: 35.0,
                  value: sendAutomatedMessage,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        sendAutomatedMessage = true;
                        callSpecificContact = false;
                        callEmergencyServices = false;
                      } else {
                        sendAutomatedMessage = false;
                      }
                    });
                  },
                ),
                const SizedBox(width: 8.0),
                Row(
                  children: [
                    const Text(
                      'Send Customized SOS Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Hero(
                      tag: 'text_editor_hero',
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => const AddTextPage(),
                            ),
                          );
                          // Handle edit button press
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Switch(
                  activeColor: const Color(0xff6750A4),
                  activeTrackColor: const Color(0xffD0BCFF),
                  inactiveThumbColor: const Color(0xff938F99),
                  inactiveTrackColor: const Color(0xff36343B),
                  splashRadius: 35.0,
                  value: callSpecificContact,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        sendAutomatedMessage = false;
                        callSpecificContact = true;
                        callEmergencyServices = false;
                      } else {
                        callSpecificContact = false;
                      }
                    });
                  },
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Call Contact',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(width: 148.0),
                Hero(
                  tag: 'call_contact_hero',
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // Handle edit button press
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => const SelectContactPage2()));
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Switch(
                  activeColor: const Color(0xff6750A4),
                  activeTrackColor: const Color(0xffD0BCFF),
                  inactiveThumbColor: const Color(0xff938F99),
                  inactiveTrackColor: const Color(0xff36343B),
                  splashRadius: 35.0,
                  value: callEmergencyServices,
                  onChanged: (value) {
                    setState(()  {
                      if (value) {
                        sendAutomatedMessage = false;
                        callSpecificContact = false;
                        callEmergencyServices = true;
                      // write the emergency number in the file
                      } else {
                        callEmergencyServices = false;
                      }
                    });
                  },
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Call Emergency Services',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
