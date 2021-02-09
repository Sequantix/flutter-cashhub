import 'dart:convert';

Socialsignin socialsigninFromJson(String str) => Socialsignin.fromJson(json.decode(str));

String socialsigninToJson(Socialsignin data) => json.encode(data.toJson());

class Socialsignin {
  Socialsignin({
    this.id,
    this.fullname,
    this.isSuccess,
    this.uemail,
    this.account,
  });

  int id;
  String fullname;
  String isSuccess;
  String uemail;
  int account;

  factory Socialsignin.fromJson(Map<String, dynamic> json) => Socialsignin(
    id: json["id"],
    fullname: json["fullname"],
    isSuccess: json["isSuccess"],
    uemail: json["uemail"],
    account: json["account"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullname": fullname,
    "isSuccess": isSuccess,
    "uemail": uemail,
    "account": account,
  };
}