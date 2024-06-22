class User {
  String id;
  String fullname;
  String profilePicture;
  String bio;
  String city;
  String email;

  User(
      {required this.id,
      required this.fullname,
      required this.profilePicture,
      required this.bio,
      required this.city,
      required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullname'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      city: json['city'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'profile_picture': profilePicture,
      'bio': bio,
      'city': city,
      'email': email,
    };
  }
}
