import 'package:flutter/material.dart';
import 'package:fluttersembastprovider/common_widgets/contact_tile.dart';
import 'package:fluttersembastprovider/models/contact_data.dart';
import 'package:provider/provider.dart';

class ContactList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ContactTile(tileIndex: index);
      },
      itemCount: Provider.of<ContactData>(context).contactsCount,
    );
  }
}
