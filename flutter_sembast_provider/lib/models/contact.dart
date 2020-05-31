class Contact {
  // Fields
  final int id;
  String name;
  String email;

  // Constructor
  Contact({this.id, this.name, this.email});

  // toMap for Sembast storage - sembast stores data as JSON strings
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // From map, for sembast storage
  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}
