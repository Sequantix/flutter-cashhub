// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.id,
    this.isSuccess,
    this.name,
    this.uemail,
    this.acount,
  });

  int id;
  String isSuccess;
  String name;
  String uemail;
  int acount;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    id: json["id"],
    isSuccess: json["isSuccess"],
    name: json["name"],
    uemail: json["uemail"],
    acount: json["acount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isSuccess": isSuccess,
    "name": name,
    "uemail": uemail,
    "acount": acount,
  };
}
