import 'dart:convert';

class CurrentUserInfo {
  int id;
  String picture;

  CurrentUserInfo({required this.id, required this.picture});

  factory CurrentUserInfo.fromJson(Map<String, dynamic> json) {
    return CurrentUserInfo(
      id: json['id'],
      picture: json['picture'],
    );
  }
}

CurrentUserInfo parseCurrentUser(String responseText) {
  final parsed = json.decode(responseText);
  return CurrentUserInfo.fromJson(parsed);
}
