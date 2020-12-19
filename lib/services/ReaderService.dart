// To parse this JSON data, do
//
//     final readerservice = readerserviceFromJson(jsonString);

import 'dart:convert';

Readerservice readerserviceFromJson(String str) => Readerservice.fromJson(json.decode(str));

String readerserviceToJson(Readerservice data) => json.encode(data.toJson());

class Readerservice {
  Readerservice({
    this.companyName,
    this.transcationdate,
    this.sku,
    this.status,
    this.tax,
    this.total,
  });

  String companyName;
  String transcationdate;
  List<Sku> sku;
  String status;
  String tax;
  String total;

  factory Readerservice.fromJson(Map<String, dynamic> json) => Readerservice(
    companyName: json["CompanyName"],
    transcationdate: json["Transcationdate"],
    sku: List<Sku>.from(json["sku"].map((x) => Sku.fromJson(x))),
    status: json["status"],
    tax: json["tax"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "CompanyName": companyName,
    "Transcationdate": transcationdate,
    "sku": List<dynamic>.from(sku.map((x) => x.toJson())),
    "status": status,
    "tax": tax,
    "total": total,
  };
}

class Sku {
  Sku({
    this.itemname,
    this.price,
    this.sku,
  });

  String itemname;
  String price;
  String sku;

  factory Sku.fromJson(Map<String, dynamic> json) => Sku(
    itemname: json["itemname"],
    price: json["price"],
    sku: json["sku"],
  );

  Map<String, dynamic> toJson() => {
    "itemname": itemname,
    "price": price,
    "sku": sku,
  };
}
