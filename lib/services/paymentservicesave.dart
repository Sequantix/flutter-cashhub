// To parse this JSON data, do
//
//     final paymentSer = paymentSerFromJson(jsonString);

import 'dart:convert';

PaymentSer paymentSerFromJson(String str) => PaymentSer.fromJson(json.decode(str));

String paymentSerToJson(PaymentSer data) => json.encode(data.toJson());

class PaymentSer {
  PaymentSer({
    this.status,
  });

  String status;

  factory PaymentSer.fromJson(Map<String, dynamic> json) => PaymentSer(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
