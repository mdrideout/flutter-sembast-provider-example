import 'package:flutter/foundation.dart';
import 'package:fluttersembastprovider/utils/database.dart';
import 'package:sembast/sembast.dart';
import 'package:random_string/random_string.dart' as random_string;
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
    // Generate a random ID based on the date and a random string for virtual zero chance of duplicates
    int _id = DateTime.now().millisecondsSinceEpoch +
        int.parse(random_string.randomNumeric(2));

    // Create the new contact object with an id (makes saving in the future easier)
    Contact newContact = Contact(id: _id);

    // Add the contact to the database with the specified id
    await _contactStore.record(_id).put(await _db, newContact.toMap());

    // Update the UI by fetching a list of contacts from the DB and setting to our provider List
    _contacts = await getAllContactsByName();

    // Return the ID
    return _id;
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

    List<Contact> contacts = contactSnapshots.map((snapshot) {
      final contact = Contact.fromMap(snapshot.value);
      return contact;
    }).toList();

    // Update UI
    _contacts = contacts;
    notifyListeners();

    return contacts;
  }

  /// Get A Contact
  Future<Contact> getContact(int id) async {
    // Get the contact JSON from the sembast DB
    var record = await _contactStore.record(id).get(await _db);
//    print("Record: " + record.toString()); // json of contact object

    // Convert to a Contact Object using the fromMap function
    Contact contact = Contact.fromMap(record);
//    print(
//        "Contact id: " + contact.id.toString()); // instance of a contact object

    return contact;
  }

  /// Save Active Contact Edits
  /// When we edit the activeContact object, we can save it to persistent storage in the sembast store
  Future<void> saveActiveContactEdits() async {
//    print("Saving Active Contact, id: " + _activeContact.id.toString());
//    print("Saving Active Contact, name: " + _activeContact.name.toString());

    // Create a finder to isolate this contact for update, by key (id).
    final finder = Finder(filter: Filter.byKey(_activeContact.id));

    // Perform the update converting, converting the contact to map, and updating the value at key identified by the finder
    await _contactStore.update(await _db, _activeContact.toMap(),
        finder: finder);

    // Refresh contacts list for UI
    await getAllContactsByName();

    return;
  }

  /// Set Active Contact
  Future<void> setActiveContact(int id) async {
    _activeContact = await getContact(id);
//    print("Active Contact Set, ID: " + _activeContact.id.toString());

    notifyListeners();
    return;
  }

  /// Delete Contact
  /// Deletes contact from Sembast persistent storage, as well as the UI via a provider update
  Future<void> deleteContact(int id) async {
    // Delete this contact from the db
    await _contactStore.record(id).delete(await _db);

    // Refresh contacts list for UI
    await getAllContactsByName();

    return;
  }

  /// Get Contacts Count
  int get contactsCount {
    return _contacts.length;
  }

  /// Get Current Provider List of Contacts
  List<Contact> get contactsList {
    return _contacts;
  }

  /// Get Active Contact
  Contact get getActiveContact {
    return _activeContact;
  }
}
