import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'mongodb.dart';
import 'contacts.dart';

class CreateContact extends StatefulWidget {
  const CreateContact({Key? key}) : super(key: key);

  @override
  CreateContactState createState() => CreateContactState();
}

class CreateContactState extends State<CreateContact> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Future<void> saveContact() async {
    // Get the values entered by the user
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String phoneNumber = phoneNumberController.text;

    await MongoDatabase.addContact(firstName, lastName, phoneNumber);
    // Save the data into the database (you need to implement the database integration)
    // Example:
    // MongoDB.saveContact(firstName, lastName, phoneNumber);

    // Close the page and pop back to the previous one
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(//this navigates to the screen after pressing the button
                             
                              MaterialPageRoute(
                                  builder: (builder) => const ContactPage()));
  }

  @override
  void dispose() {
    // Clean up the controllers
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211F26),
      appBar: AppBar(
        backgroundColor: const Color(0xFF211F26),
        title: const Text(
          'Add Contact',
          style: TextStyle(color: Color.fromARGB(255, 230, 224, 233)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xff2C3D7A),
              padding: EdgeInsets.fromLTRB(30.sp, 30.sp, 30.sp, 30.sp),
              child: Center(
                child: SizedBox(
                  height: 150.sp,
                  width: 150.sp,
                  child: Image.asset(
                    'assets/images/contact_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.sp, left: 80.sp),
              child: Container(
                width: 200.sp,
                height: 60.sp,
                decoration: BoxDecoration(
                  color: const Color(0xff36343B),
                  borderRadius: BorderRadius.circular(5.sp),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'First Name',
                      labelStyle: const TextStyle(
                        color: Color(0xffCAC4D0),
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(-1.sp, -5.sp, 0.sp, 0.sp),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.sp, left: 80.sp),
              child: Container(
                width: 200.sp,
                height: 60.sp,
                decoration: BoxDecoration(
                  color: const Color(0xff36343B),
                  borderRadius: BorderRadius.circular(5.sp),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Last Name',
                      labelStyle: const TextStyle(
                        color: Color(0xffCAC4D0),
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(-1.sp, -5.sp, 0.sp, 0.sp),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.sp, left: 80.sp),
              child: Container(
                width: 200.sp,
                height: 60.sp,
                decoration: BoxDecoration(
                  color: const Color(0xff36343B),
                  borderRadius: BorderRadius.circular(5.sp),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(
                        color: Color(0xffCAC4D0),
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(-1.sp, -5.sp, 0.sp, 0.sp),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.sp, left: 0.sp, bottom: 60.sp),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: saveContact,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(100.sp, 40.sp)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(1.w)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff4A4458)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: const Color(0xffCCC2DC), fontSize: 18.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
