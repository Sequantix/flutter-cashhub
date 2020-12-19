import 'dart:convert';

Signin signinFromJson(String str) => Signin.fromJson(json.decode(str));

String signinToJson(Signin data) => json.encode(data.toJson());

class Signin {
  Signin({
    this.status,
    this.id,
  });

  String status;
  int id;

  factory Signin.fromJson(Map<String, dynamic> json) => Signin(
    status: json["status"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "id": id,
  };
}
