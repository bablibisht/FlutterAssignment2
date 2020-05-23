import 'package:contact/add_contact.dart';
import 'package:contact/bloc/contact_bloc.dart';
import 'package:contact/model/contact.dart';
import 'package:contact/utility/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactList extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _ContactList();
}

class _ContactList extends State<ContactList> with WidgetsBindingObserver {
  ContactBloc _contactBloc = ContactBloc();
  AppLifecycleState _notification;

  @override
  void initState() {
    debugPrint("init");
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _contactBloc.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      _notification = state;
     // debugPrint("Hello1 Test1 $state");
    });
    //debugPrint("Hello Test1 $state");
    if (state == AppLifecycleState.paused) {
      // went to Background
    }
    if (state == AppLifecycleState.resumed) {
      // debugPrint("Hello Test");
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Last notification: $_notification');
    return Container(
      child: getContactWidget(),
    );
  }

  Widget getContactWidget() {
    return StreamBuilder(
      stream: _contactBloc.contacts,
      builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) =>
          getContactCardWidget(snapshot),
    );
  }

  Widget getContactCardWidget(AsyncSnapshot<List<Contact>> snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              _contactBloc
                  .deleteContact(snapshot.data[index].id)
                  .then((value) => onContactDeleted(value));
            },
            onTap: () {
              navigateToUpdateContact(snapshot.data[index]);
            },
            child: Card(
              elevation: 5.0,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Utility.loadUserImage(
                            snapshot.data[index].image, 60.0, 60.0),
                        SizedBox(width: 10.0,),
                        Column(
                          children: <Widget>[
                            Text(snapshot.data[index].name),
                            Text(snapshot.data[index].mobile)
                          ],
                        ),
                      ],
                    ),

                    updateFavIcon(snapshot.data[index].isFav)
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: loadContacts(),
      );
    }
  }

  Widget loadContacts() {
    _contactBloc.getContacts();
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget updateFavIcon(int favStatus) {
    if (favStatus == 0) {
      return Icon(Icons.star_border);
    } else {
      return Icon(Icons.star);
    }
  }

  void onContactDeleted(int value) {
    if (value != -1) {
      Fluttertoast.showToast(msg: 'Contact deleted successfully!!!!');
      loadContacts();
    } else
      Fluttertoast.showToast(msg: 'Error in contact delete.');
  }

  void navigateToUpdateContact(Contact selContact) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddContact(),
        settings: RouteSettings(arguments: selContact))).whenComplete(() => loadContacts());
  }
}
