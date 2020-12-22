import 'dart:convert';

Readerservice readerserviceFromJson(String str) => Readerservice.fromJson(json.decode(str));

String readerserviceToJson(Readerservice data) => json.encode(data.toJson());

class Readerservice {
  Readerservice({
    this.items,
    this.merchantName,
    this.total,
    this.totalTax,
    this.transactionDate,
    this.status,
  });

  List<Item> items;
  String merchantName;
  String total;
  String totalTax;
  String transactionDate;
  bool status;

  factory Readerservice.fromJson(Map<String, dynamic> json) => Readerservice(
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
    merchantName: json["Merchant Name"],
    total: json["Total"],
    totalTax: json["TotalTax"],
    transactionDate: json["Transaction Date"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
    "Merchant Name": merchantName,
    "Total": total,
    "TotalTax": totalTax,
    "Transaction Date": transactionDate,
    "status": status,
  };
}

class Item {
  Item({
    this.discount,
    this.itemName,
    this.totalPrice,
    this.sku,
  });

  String discount;
  String itemName;
  String totalPrice;
  String sku;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    discount: json["Discount"],
    itemName: json["ItemName"],
    totalPrice: json["TotalPrice"],
    sku: json["sku"],
  );

  Map<String, dynamic> toJson() => {
    "Discount": discount,
    "ItemName": itemName,
    "TotalPrice": totalPrice,
    "sku": sku,
  };
}