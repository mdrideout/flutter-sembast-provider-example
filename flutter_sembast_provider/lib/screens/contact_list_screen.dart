import 'package:flutter/material.dart';
import 'package:fluttersembastprovider/common_widgets/contact_list.dart';
import 'package:fluttersembastprovider/models/contact_data.dart';
import 'package:fluttersembastprovider/screens/contact_edit_screen.dart';
import 'package:provider/provider.dart';

class ContactListScreen extends StatelessWidget {
  static const String screenId = '/contact_list_screen';

  /// Returns a helpful message if there are not yet any contacts
  Widget helpTip() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "No Contacts Found",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Text("Tap the icon in the bottom right corner to add a new contact."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get contact list from db on initial build
    Provider.of<ContactData>(context, listen: false).getAllContactsByName();

    return Consumer<ContactData>(builder: (context, contactData, child) {
      int numOfContacts = contactData.contactsCount;

      return Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: (numOfContacts == 0) ? helpTip() : ContactList(),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add New Contact',
          child: Icon(Icons.person_add),
          onPressed: () async {
            int newContactId =
                await Provider.of<ContactData>(context, listen: false)
                    .createNewContact();
            print("New contact created with id of: " + newContactId.toString());

            // Set the new contact as the "activeContact"
            await Provider.of<ContactData>(context, listen: false)
                .setActiveContact(newContactId);

            // Navigate to the activeContact editor
            Navigator.pushNamed(context, ContactEditScreen.screenId);
          },
        ),
      );
    });
  }
}
