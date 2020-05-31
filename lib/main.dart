import 'package:flutter/material.dart';
import 'package:fluttersembastprovider/models/contact_data.dart';
import 'package:fluttersembastprovider/screens/contact_edit_screen.dart';
import 'package:fluttersembastprovider/screens/contact_list_screen.dart';
import 'package:fluttersembastprovider/screens/contact_view_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast_io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactData(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: ContactListScreen.screenId,
          routes: {
            ContactListScreen.screenId: (context) => ContactListScreen(),
            ContactEditScreen.screenId: (context) => ContactEditScreen(),
            ContactViewScreen.screenId: (context) => ContactViewScreen(),
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return ContactListScreen();
  }
}
