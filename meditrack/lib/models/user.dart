class User {
  final int user_id;
  final String first_name;
  final String last_name;
  final String email;
  final String role;
  String? phone;
  String? last_login;

  User({
    required this.user_id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.role,
    this.phone,
    this.last_login,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_id: json['user_id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      last_login: json['last_login']
    );
  }

  @override
  String toString() {
    return 'User(user_id: $user_id, first_name: $first_name, last_name: $last_name, email: $email, phone: $phone, last_login: $last_login, role: $role)';
  }
}
