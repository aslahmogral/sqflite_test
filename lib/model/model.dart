class User {
  final int? id;
  final String name;
  final int age;

  User({this.id, required this.name, required this.age});

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Create a User from a Map object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
    );
  }
}