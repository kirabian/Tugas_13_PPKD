// lib/model/user.dart

class User {
  final int? id;
  final String email;
  final String password;
  final String name;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'password': password, 'name': name};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
    );
  }
}
