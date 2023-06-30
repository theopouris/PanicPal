import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await Db.create(
        "mongodb+srv://omada18:Infinity!2@cluster0.w7a3ozp.mongodb.net/contacts");
    await db.open();

    final collection = db.collection("contacts");
    final contacts = await collection.find().toList();

    return contacts.map((contact) => contact as Map<String, dynamic>).toList();
  }

  static Future<void> deleteContact(String id) async {
    var db = await Db.create(
        "mongodb+srv://omada18:Infinity!2@cluster0.w7a3ozp.mongodb.net/contacts");
    await db.open();
    var collection = db.collection("contacts");
    await collection.remove(where.eq("_id", id));
    await db.close();
  }

  static Future<void> addContact(
      String firstName, String lastName, String phoneNumber) async {
    var db = await Db.create(
        "mongodb+srv://omada18:Infinity!2@cluster0.w7a3ozp.mongodb.net/contacts");
    await db.open();
    var collection = db.collection("contacts");
    var document = {
      '_id': ObjectId().toString(),
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
    };

    await collection.insert(document);

    await db.close();
  }
  
  static Future<Map<String, dynamic>> fetchContactById(String contactId) async {
    var db = await Db.create(
        "mongodb+srv://omada18:Infinity!2@cluster0.w7a3ozp.mongodb.net/contacts");
    await db.open();
    var collection = db.collection("contacts");
    
    final contact = await collection.findOne(where.eq("_id", contactId));

    await db.close();

    return contact ?? {}; // Return an empty map if no contact is found
  }
}
