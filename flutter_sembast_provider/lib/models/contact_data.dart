import 'package:flutter/foundation.dart';
import 'package:fluttersembastprovider/utils/database.dart';
import 'package:sembast/sembast.dart';
import "contact.dart";

class ContactData extends ChangeNotifier {
  // Sembast database settings
  static const String CONTACT_STORE_NAME = 'contacts';
  final _contactStore = intMapStoreFactory.store(CONTACT_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  // Initialize our list of contacts - for provider
  List<Contact> _contacts = [];

  // Keep track of our "active" contact - for provider
  Contact _activeContact;

  /// Create New Contact
  /// Adds a new empty contact to the database, returns the ID
  Future<int> createNewContact() async {
    // Create the new contact
    Contact newContact = Contact();

    // Add the contact to the database
    int _contactId = await _contactStore.add(await _db, newContact.toMap());

    // Update the UI by fetching a list of contacts from the DB and setting to our provider List
    _contacts = await getAllContactsByName();

    // Notify our listeners to update
    notifyListeners();

    // Return the ID
    return _contactId;
  }

  /// Get All Contacts By Name
  Future<List<Contact>> getAllContactsByName() async {
    // Finder allows for filtering / sorting
    final finder = Finder(sortOrders: [SortOrder('name')]);

    // Get the data using our finder for sorting
    final contactSnapshots = await _contactStore.find(
      await _db,
      finder: finder,
    );

    return contactSnapshots.map((snapshot) {
      final contact = Contact.fromMap(snapshot.value);

      contact.id = snapshot.key;
      return contact;
    }).toList();
  }

  // TODO: Get All Contacts

  // TODO: Get A Contact

  // TODO: Contacts Count

  // TODO: Save Contact

  // TODO: Delete Contact

  // TODO: Set Active Contact

  // TODO: Get Active Contact
}
