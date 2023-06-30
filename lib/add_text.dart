import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'select_contact_1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTextPage extends StatefulWidget {
  const AddTextPage({Key? key}) : super(key: key);

  @override
  _AddTextPageState createState() => _AddTextPageState();
}

class _AddTextPageState extends State<AddTextPage> {
  final TextEditingController _textController = TextEditingController();

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
      backgroundColor: const Color(0xff141218),
      appBar: AppBar(
        title: const Text('Customize your message'),
      ),
      body: 
      
      Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          
          children: [
            TextField(
              controller: _textController,
              style: const TextStyle(color:  Color(0xffCAC4D0)),
              decoration: const InputDecoration(
                labelText: 'Enter text',
                hintText: 'Help me!',
                labelStyle: TextStyle(
                  color:  Color(0xffCAC4D0)
                ),
                hintStyle: TextStyle(
                  color:  Color(0xffCAC4D0)
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 60.sp),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final directory = await getApplicationDocumentsDirectory();
                            final filePath = '${directory.path}/automatedmessage.txt';
                            await createFile(filePath);
                            await writeToFile(_textController.text, filePath);
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectContactPage(filePath: filePath),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(40.sp, 40.sp)),
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(1.w)),
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff4A4458)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child:  Text(
                            'Save',
                            style: TextStyle(
                              color: const Color(0xffCCC2DC),
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.sp),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(40.sp, 40.sp)),
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(1.w)),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child:  Text(
                            'Cancel',
                            style: TextStyle(
                              color: const Color(0xffD9D9D9),
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
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
