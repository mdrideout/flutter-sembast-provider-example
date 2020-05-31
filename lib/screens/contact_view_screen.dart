/// Client Screen
/// Builds a view of the client based on the provided client key.
/// We get the client data using the key - as a Consumer of provider

import 'package:flutter/material.dart';
import 'package:fluttersembastprovider/models/contact.dart';
import 'package:fluttersembastprovider/models/contact_data.dart';
import 'package:fluttersembastprovider/screens/contact_edit_screen.dart';
import 'package:fluttersembastprovider/screens/contact_list_screen.dart';
import 'package:provider/provider.dart';

class ContactViewScreen extends StatelessWidget {
  static const String screenId = '/contact_view_screen';

  /// Returns a helpful message if there are not yet any clients
  /// else, returns the ClientList
  Widget helpTip() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Start Adding Items",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Text("Tap the icon in the bottom right corner to add a new item."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Delete confirmation dialogue
    void _showDeleteConfirmation(activeContact) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are You Sure?"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You are about to delete ${activeContact.name}.'),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'You cannot undo this action.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Delete'),
                onPressed: () {
                  print("Deleting ${activeContact.name}...");

                  // call deletion function
                  Provider.of<ContactData>(context, listen: false)
                      .deleteContact(activeContact.id);

                  // Pop until we get back to the contact list screen
                  Navigator.popUntil(
                      context, ModalRoute.withName(ContactListScreen.screenId));
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  print("Canceled delete.");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Consumer<ContactData>(builder: (context, contactData, child) {
      Contact activeContact = contactData.getActiveContact;

      if (activeContact != null) {
        return Scaffold(
          appBar: AppBar(
            title: Text(activeContact.name),
            actions: <Widget>[
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (selection) {
                  switch (selection) {
                    case 1:
                      print("Selected Edit");

                      // Navigate to the activeContact editor
                      Navigator.pushNamed(context, ContactEditScreen.screenId);
                      break;

                    case 2:
                      print("Selected Delete");
                      _showDeleteConfirmation(activeContact);
                      break;
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text("Edit"),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text("Delete"),
                    value: 2,
                  ),
                ],
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      activeContact.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      activeContact.email,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Edit Contact',
            child: Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the activeContact editor
              Navigator.pushNamed(context, ContactEditScreen.screenId);
            },
          ),
        );
      } else {
        return Scaffold(
            appBar: AppBar(
          title: Text("Deleting..."),
        ));
      }
    });
  }
}
