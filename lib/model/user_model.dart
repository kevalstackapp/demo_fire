// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    this.uId,
    this.name,
    this.phone,
    this.email,
    this.userImg,
  });

  String? uId;
  String? name;
  String? phone;
  String? email;
  String? userImg;

  factory UserModel.fromJson(Map json) => UserModel(
    uId: json["uId"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    userImg: json["userImg"],
  );

  Map<String, dynamic> toJson() => {
    "uId": uId,
    "name": name,
    "phone": phone,
    "email": email,
    "userImg": userImg,
  };
}
