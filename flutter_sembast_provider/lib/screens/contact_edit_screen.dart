import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersembastprovider/models/contact.dart';
import 'package:fluttersembastprovider/models/contact_data.dart';
import 'package:provider/provider.dart';
import 'package:tpag_app/common_widgets/styled_button.dart';
import 'package:tpag_app/models/client.dart';
import 'package:tpag_app/models/client_data.dart';

import 'auth_password_reset_screen.dart';

/// Client Screen
/// Builds a view of the client based on the provided client key.
/// We get the client data using the key - as a Consumer of provider
class AuthLoginScreen extends StatefulWidget {
  static const String screenId = '/auth_login_screen';

  @override
  _AuthLoginScreenState createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  String email;
  String emailError;
  String password;
  String passwordError;
  bool _showSpinner = false;

  Widget loginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Log In",
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
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Email Address',
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
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
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required.';
                    }
                    if (passwordError != null) {
                      return passwordError;
                    }
                    return null;
                  },
                ),
                StyledButton(
                  buttonText: 'Log In',
                  buttonColor: Colors.blue,
                  buttonOnPressed: () async {
                    // Reset firebase auth validators
                    setState(() {
                      emailError = null;
                    });
                    setState(() {
                      passwordError = null;
                    });

                    // Validate the form client-side, then submit to firebase auth
                    if (_formKey.currentState.validate()) {
                      try {
                        // Show spinner
                        setState(() {
                          _showSpinner = true;
                        });

                        // Pass to firebase auth and await response
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                        // Hide spinner
                        setState(() {
                          _showSpinner = false;
                        });

                        // If user successfully logged in, pop this screen back to previous
                        if (user != null) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        // Hide spinner
                        setState(() {
                          _showSpinner = false;
                        });
                        print("Auth error.");
                        print(e.code);

                        // Set new errors on form based on firebase auth feedback
                        if (e.code == "ERROR_INVALID_EMAIL") {
                          setState(() {
                            emailError = "Invalid Email Address";
                          });
                        }

                        if (e.code == "ERROR_USER_NOT_FOUND") {
                          setState(() {
                            emailError =
                                "No accounts for this email address found.";
                          });
                        }

                        if (e.code == "ERROR_WRONG_PASSWORD") {
                          setState(() {
                            passwordError = "Incorrect password.";
                          });
                        }

                        // Re-Run validation
                        _formKey.currentState.validate();
                      }
                    }
                  },
                ),
                SizedBox(height: 10.0),
                FlatButton(
                  child: Text(
                    "forgot password",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AuthPasswordResetScreen.screenId);
                  },
                ),
                if (_showSpinner) CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactData>(builder: (context, clientData, child) {
      Contact activeContact = clientData.getActiveContact();

      return Scaffold(
        appBar: AppBar(
          title: Text("Log In"),
          actions: <Widget>[],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: loginForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
