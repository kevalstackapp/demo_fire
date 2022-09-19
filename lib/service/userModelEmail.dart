// To parse this JSON data, do
//
//     final userModelEmail = userModelEmailFromJson(jsonString);

import 'dart:convert';

List<UserModelEmail> userModelEmailFromJson(String str) => List<UserModelEmail>.from(json.decode(str).map((x) => UserModelEmail.fromJson(x)));

String userModelEmailToJson(List<UserModelEmail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModelEmail {
  UserModelEmail({
    this.uId,
    this.email,
    this.password,
  });

  String? uId;
  String? email;
  String? password;

  factory UserModelEmail.fromJson(Map<String, dynamic> json) => UserModelEmail(
    uId: json["uId"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "uId": uId,
    "email": email,
    "password": password,
  };
}
