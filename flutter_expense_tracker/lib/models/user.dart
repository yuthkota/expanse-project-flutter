class User {
  final int id;
  final String username;
  final String? email;
  final String? token;

  User({
    required this.id,
    required this.username,
    this.email,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'],
      username: json['username'],
      token: json['token'],
    );
  }
}
