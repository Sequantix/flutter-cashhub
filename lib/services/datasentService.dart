// To parse this JSON data, do
//
//     final datasentService = datasentServiceFromJson(jsonString);

import 'dart:convert';

DatasentService datasentServiceFromJson(String str) => DatasentService.fromJson(json.decode(str));

String datasentServiceToJson(DatasentService data) => json.encode(data.toJson());

class DatasentService {
  DatasentService({
    this.status,
  });

  String status;

  factory DatasentService.fromJson(Map<String, dynamic> json) => DatasentService(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
