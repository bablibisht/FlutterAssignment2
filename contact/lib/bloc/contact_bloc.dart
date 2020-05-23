import 'dart:async';
import 'package:contact/model/contact.dart';
import 'package:contact/repository/contact_repository.dart';

class ContactBloc {
  //Get instance of the Repository
  final _contactRepository = ContactRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _contactController = StreamController<List<Contact>>.broadcast();

  get contacts => _contactController.stream;

  ContactBloc() {
    getContacts();
  }

  getContacts() async {
    _contactController.sink.add(await _contactRepository.getAllContacts());
  }

  Future<int> addContact(Contact contact) async {
    var result = await _contactRepository.insertContact(contact);
    return result;
  }

  getFavContacts() async {
    _contactController.sink.add(await _contactRepository.getFavContacts());
  }

  Future<int> deleteContact(int id) async {
    var result = await _contactRepository.deleteContact(id);
    return result;
  }

  Future<int> updateContact(Contact contact) async{
    var result = await _contactRepository.updateContact(contact);
    return result;
  }

  dispose() {
    _contactController.close();
  }
}