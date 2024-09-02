import 'dart:convert';

class UserData {
  String id;
  String fullname;
  String picture;
  String bio;
  String city;
  String email;

  UserData(
      {required this.id,
      required this.fullname,
      required this.picture,
      required this.bio,
      required this.city,
      required this.email});

  UserData.profileInfo({
    this.id = "",
    required this.fullname,
    this.email = "",
    required this.picture,
    required this.bio,
    required this.city,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      fullname: json['fullname'],
      picture: json['picture'],
      bio: json['bio'],
      city: json['city'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'picture': picture,
      'bio': bio,
      'city': city,
      'email': email,
    };
  }
}

UserData parseUser(String responseText) {
  final parsed = json.decode(responseText);
  return UserData(
    id: parsed['id'],
    fullname: parsed['fullname'],
    picture: parsed['picture'],
    bio: parsed['bio'],
    city: parsed['city'],
    email: parsed['email'],
  );
}
