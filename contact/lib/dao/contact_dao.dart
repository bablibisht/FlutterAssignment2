import 'dart:async';
import 'package:contact/database/database_provider.dart';
import 'package:contact/model/contact.dart';

class ContactDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createContact(Contact contact) async {
    final db = await dbProvider.getDatabase;
    var result = db.insert(contactTABLE, contact.toJson());
    return result;
  }

  Future<List<Contact>> getContacts() async {
    final db = await dbProvider.getDatabase;

    List<Map<String, dynamic>> result;
    result = await db.query(contactTABLE, orderBy: "name COLLATE NOCASE ASC");
    List<Contact> contacts = result.isNotEmpty
        ? result.map((item) => Contact.fromJson(item)).toList()
        : [];
    return contacts;
  }

  Future<List<Contact>> getFavContacts() async {
    final db = await dbProvider.getDatabase;
    List<Map<String, dynamic>> result;
    result = await db.query(contactTABLE,
        where: "isFav=1", orderBy: "name COLLATE NOCASE ASC");
    List<Contact> contacts = result.isNotEmpty
        ? result.map((item) => Contact.fromJson(item)).toList()
        : [];
    return contacts;
  }

  Future<int> deleteContact(int id) async {
    final db = await dbProvider.getDatabase;
    var result =
        await db.delete(contactTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future<int> updateContact(Contact contact) async {
    final db = await dbProvider.getDatabase;
    var result = await db.update(contactTABLE, contact.toJson(),
        where: "id = ?", whereArgs: [contact.id]);
    return result;
  }
}
