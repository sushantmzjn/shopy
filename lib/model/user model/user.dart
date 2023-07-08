import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String id;
  @HiveField(1)
  String email;
  @HiveField(2)
  String token;
  @HiveField(3)
  String username;



  User({
   required this.id,
   required this.email,
   required this.token,
   required this.username,


  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: json['id'],
        email: json['email'],
        token: json['token'],
        username: json['username'],

    );
  }
}
