import 'package:contact/add_contact.dart';
import 'package:contact/contact_list.dart';
import 'package:contact/favourites_list.dart';
import 'package:contact/model/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home>{

  String _selectedItem = "contacts";
  String _title = "Contacts";



  _getDrawerScreen(String screenTag){
    switch(screenTag){
      case "contacts":{
        _title = "Contacts";
        return ContactList();
      }
      case "fav":
        {
          _title = "Favourites";
          return FavouriteList();
        }
      case "add": {
        _title = "Add Contact";
          return AddContact();
        }

    }
  }

  _onItemSelection(String newItem){
    setState(() {
      _selectedItem = newItem;
      _getDrawerScreen(_selectedItem);
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _getDrawerScreen(_selectedItem),
      drawer: Drawer(
        child: ListView( 
          children: <Widget>[
            DrawerHeader(
              child: Text('Header'),
              decoration: BoxDecoration(
                color: Colors.blue
              ),
            ),
            ListTile(
              title: Text('Contact List'),
              selected: "contacts" == _selectedItem,
              onTap: () {
                _onItemSelection('contacts');
                //Navigator.pop(context);
              }
            ),
            ListTile(
              title: Text('Favourites'),
              selected: "fav" == _selectedItem,
              onTap: () {
                _onItemSelection('fav');
               /* Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavouriteList(),));*/
              },
            ),
            ListTile(
              title: Text('Add Contact'),
              selected: "add" == _selectedItem,
              onTap: () {
                _onItemSelection('add');
                /*Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddContact(),));*/
              },
            )
          ],
        ),
      ),
    );
  }



}