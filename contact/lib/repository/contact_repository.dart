import 'package:contact/dao/contact_dao.dart';
import 'package:contact/model/contact.dart';

class ContactRepository {
  final contactDao = ContactDao();

  Future getAllContacts() => contactDao.getContacts();

  Future<int> insertContact(Contact contact) => contactDao.createContact(contact);

  Future getFavContacts() => contactDao.getFavContacts();

  Future<int> deleteContact(int id) => contactDao.deleteContact(id);

  Future updateContact(Contact contact) => contactDao.updateContact(contact);

}