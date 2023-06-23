import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'mongodb.dart';
import 'create_contacts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (BuildContext context, Widget? child) {
        return const MaterialApp(
          home: ContactPage(),
        );
      },
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F26),
      appBar: AppBar(
        backgroundColor: const Color(0xFF211F26),
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(color: Color.fromARGB(255, 230, 224, 233)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Handle going to previous page
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push( //this navigates to the screen after pressing the button
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const CreateContact()));
            },
          ),
        ],
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10.sp, 40.sp, 30.sp, 40.sp),
                  child: Text(
                    'Select your emergency contacts',
                    style: TextStyle(fontSize: 18.sp, color:const Color.fromARGB(255, 230, 224, 233)),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(1.sp, 10.sp, 10.sp, 10.sp),
                    color: const Color(0xFF141218),
                    child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        final firstName = contact['first_name'] ?? '';
                        final lastName = contact['last_name'] ?? '';
                        final fullName = '$firstName $lastName';
                        final firstLetter = fullName.isNotEmpty ? fullName[0] : '';

                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            await MongoDatabase.deleteContact(contact['_id']);
                            // Add your logic here to delete the contact
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 16.sp),
                            color: const Color.fromARGB(255, 179, 49, 39),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF2C3D7A),
                              child: Text(
                                firstLetter.toUpperCase(),
                                style: TextStyle(fontSize: 16.sp, color: const Color(0xFFEADDFF)),
                              ),
                            ),
                            title: Text(
                              fullName,
                              style:  TextStyle(
                                color: const Color.fromARGB(255, 230, 224, 233),
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
