class GetUser {
  String id;
  String email;
  String full_name;
  String password;

  GetUser({
   required this.id,
   required this.email,
   required this.full_name,
    required this.password
  });

  factory GetUser.fromJson(Map<String, dynamic> json) {
    return GetUser(
        email: json['email'] ?? '',
        id: json['id'] ?? '',
        full_name: json['full_name'] ?? '',
        password: json['password'] ?? '',
    );
  }
}
