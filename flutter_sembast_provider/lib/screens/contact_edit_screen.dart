import 'package:flutter/material.dart';
import 'package:fluttersembastprovider/models/contact.dart';
import 'package:fluttersembastprovider/models/contact_data.dart';
import 'package:provider/provider.dart';

/// Contact Edit Screen
/// Edits the "activeContact" and allows saving.
class ContactEditScreen extends StatefulWidget {
  static const String screenId = '/contact_edit_screen';

  @override
  _ContactEditScreenState createState() => _ContactEditScreenState();
}

class _ContactEditScreenState extends State<ContactEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variables to hold validation errors
  String emailError;
  String nameError;

  // Set Up Field Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // initState load activeContact values into the local state text controllers
  @override
  void initState() {
    Contact activeContact =
        Provider.of<ContactData>(context, listen: false).getActiveContact;

    print("Active Contact Name: " + activeContact.name.toString());

    _emailController.text = activeContact.email ?? '';
    _nameController.text = activeContact.name ?? '';

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget editForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Edit Contact",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required.';
                    }
                    if (nameError != null) {
                      return nameError;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required.';
                    }
                    if (emailError != null) {
                      return emailError;
                    }
                    return null;
                  },
                ),
                RaisedButton(
                  child: Text("Save"),
                  onPressed: () async {
                    // Reset optional validators
                    setState(() {
                      nameError = null;
                    });
                    setState(() {
                      emailError = null;
                    });

                    // Optional validators can be performed here
                    // set nameError or emailError to the appropriate error string for the user
                    // to block form submission and show the error.
                    // ex: checking for valid email.

                    // Validate the form client-side, then submit to firebase auth
                    if (_formKey.currentState.validate()) {
                      try {
                        // SAVE
                        Contact activeContact =
                            Provider.of<ContactData>(context, listen: false)
                                .getActiveContact;

                        // Update activeContact with local state text
                        activeContact.email = _emailController.text;
                        activeContact.name = _nameController.text;

                        // Save activeContact to persistent storage and update contact list
                        await Provider.of<ContactData>(context, listen: false)
                            .saveActiveContactEdits();

                        // POP to return to the contacts list
                        Navigator.pop(context);
                      } catch (e) {
                        print(e.code);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
        actions: <Widget>[],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: editForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
