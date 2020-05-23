import 'dart:convert';
import 'dart:io';

import 'package:contact/bloc/contact_bloc.dart';
import 'package:contact/model/contact.dart';
import 'package:contact/utility/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddContact();
}

class _AddContact extends State {
  final _formKey = GlobalKey<FormState>();
  ContactBloc _contactBloc = ContactBloc();
  Contact _contact = Contact();
  Future<int> _dbResult;
  Future<File> _selImage;
  

  void _chooseImage() {
    _selImage = Utility.pickImage(context);
    setState(() {
      //_contact.image = Utility.base64String(_selImage.readAsBytesSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    var tempContact = ModalRoute.of(context).settings.arguments;
    if (tempContact != null) _contact = tempContact;
    debugPrint("Id is ${_contact.id}");
    return Scaffold(
        appBar: tempContact != null
            ? AppBar(
                title: Text('Update Contact'),
              )
            : null,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: _chooseImage,
                    child: FutureBuilder(
                      future: _selImage,
                      builder: (context, AsyncSnapshot<File> snapshot) {
                        if (snapshot.hasData) {
                          _contact.image = Utility.base64String(
                              snapshot.data.readAsBytesSync());
                          return Image(image: FileImage(snapshot.data));
                        } else if (snapshot.hasError)
                          debugPrint('Unable to load image');
                        return loadInitialImage();
                      },
                    ),
                  ),
                  TextFormField(
                    initialValue: _contact.name,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: _isEmpty,
                    onSaved: (newValue) => _contact.name = newValue,
                  ),
                  TextFormField(
                    initialValue: _contact.mobile,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Mobile'),
                    validator: _isEmpty,
                    onSaved: (newValue) => _contact.mobile = newValue,
                  ),
                  TextFormField(
                    initialValue: _contact.landline,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Landline Number'),
                    validator: _isEmpty,
                    onSaved: (newValue) => _contact.landline = newValue,
                  ),
                  CheckboxListTile(
                    title: Text("Add to Favourite"),
                    value: _contact.isFav == 1 ? true : false,
                    onChanged: (value) {
                      //without setstate checkbox click UI not updating
                      setState(() {
                        value ? _contact.isFav = 1 : _contact.isFav = 0;
                      });
                    },
                    /*onChanged: (newValue) {
                      setState(() {
                        _isFavMarked = newValue;
                      });
                      if(newValue)
                        _contact.isFav = 1;
                      else
                        _contact.isFav = 0;
                    },*/
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                      child: Text(
                        'Save',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blueAccent,
                      onPressed: _submitContact),
                ],
              )),
        )),);
  }

  void _submitContact() {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _saveContactinDb();
    }
  }

  void _saveContactinDb() {
    var message = "";
    if (_contact.id == null) {
      _dbResult = _contactBloc.addContact(_contact);
      message = 'Contact added successfully!!!';
    } else {
      _dbResult = _contactBloc.updateContact(_contact);
      message = 'Contact updated successfully!!!';
    }
    _dbResult.then((value) {
      if (message.contains('updated')) Navigator.pop(context);
      if (value != -1) {
        Fluttertoast.showToast(msg: message);
      } else
        Fluttertoast.showToast(msg: 'Something went wrong.');
    });
  }

  String _isEmpty(String data) {
    if (data.isEmpty)
      return 'Field cannot empty';
    else
      null;
  }

  Widget loadInitialImage() {
    if (_contact.image != null) {
      return Container(
        child: Utility.loadUserImage(_contact.image, 120.0, 120.0),
      );
    } else {
      AssetImage assetImage = AssetImage('assets/images/placeholder.png');
      Image image = Image(image: assetImage, width: 120.0, height: 120.0);
      return Container(
        child: image,
      );
    }
  }
}
