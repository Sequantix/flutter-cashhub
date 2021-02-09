import 'dart:convert';

Pricedrops pricedropsFromJson(String str) => Pricedrops.fromJson(json.decode(str));

String pricedropsToJson(Pricedrops data) => json.encode(data.toJson());

class Pricedrops {
  Pricedrops({
    this.data,
  });

  List<Datum> data;

  factory Pricedrops.fromJson(Map<String, dynamic> json) => Pricedrops(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.sku,
    this.proName,
    this.merName,
    this.lastPrice,
    this.currentPrice,
    this.createdDate,
  });

  String sku;
  String proName;
  String merName;
  String lastPrice;
  String currentPrice;
  DateTime createdDate;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    sku: json["sku"],
    proName: json["pro_name"],
    merName: json["mer_name"],
    lastPrice: json["last_price"],
    currentPrice: json["current_price"],
    createdDate: DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "sku": sku,
    "pro_name": proName,
    "mer_name": merName,
    "last_price": lastPrice,
    "current_price": currentPrice,
    "createdDate": createdDate.toIso8601String(),
  };
}
