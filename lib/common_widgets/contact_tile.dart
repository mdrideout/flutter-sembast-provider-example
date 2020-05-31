import 'package:flutter/material.dart';
import 'package:fluttersembastprovider/models/contact.dart';
import 'package:fluttersembastprovider/models/contact_data.dart';
import 'package:fluttersembastprovider/screens/contact_view_screen.dart';
import 'package:provider/provider.dart';

class ContactTile extends StatelessWidget {
  final int tileIndex;

  // Constructor
  ContactTile({this.tileIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactData>(
      builder: (context, contactData, child) {
        Contact currentContact = contactData.contactsList[tileIndex];

        return ListTile(
          onTap: () {
            // Set activeContact
            Provider.of<ContactData>(context, listen: false)
                .setActiveContact(currentContact.id);

            // Navigate to view
            Navigator.pushNamed(context, ContactViewScreen.screenId);
          },
          title: Text(
            currentContact.name ?? "New Contact",
          ),
          subtitle: Text(
            currentContact.email ?? "",
          ),
        );
      },
    );
  }
}
