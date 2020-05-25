class Contact {
  // Fields
  int id;
  final String name;
  final String email;

  // Constructor
  Contact({this.name, this.email});

  // toMap for Sembast storage - sembast stores data as JSON strings
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  // From map, for sembast storage
  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      email: map['email'],
    );
  }
}
