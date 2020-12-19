import 'dart:convert';

SearchService searchServiceFromJson(String str) => SearchService.fromJson(json.decode(str));

String searchServiceToJson(SearchService data) => json.encode(data.toJson());

class SearchService {
  SearchService({
    this.odataContext,
    this.value,
  });

  String odataContext;
  List<Value> value;

  factory SearchService.fromJson(Map<String, dynamic> json) => SearchService(
    odataContext: json["@odata.context"],
    value: List<Value>.from(json["value"].map((x) => Value.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "@odata.context": odataContext,
    "value": List<dynamic>.from(value.map((x) => x.toJson())),
  };
}

class Value {
  Value({
    this.searchScore,
    this.status,
    this.emailId,
    this.fullName,
    this.merchantName,
    this.transactionDate,
    this.tax,
    this.total,
    this.discount,
    this.blobUrl,
    this.createdDate,
    this.itemName,
    this.sku,
    this.price,
    this.expr2,
    this.id,
  });

  double searchScore;
  String status;
  String emailId;
  String fullName;
  String merchantName;
  DateTime transactionDate;
  String tax;
  String total;
  String discount;
  String blobUrl;
  DateTime createdDate;
  String itemName;
  String sku;
  String price;
  String expr2;
  String id;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    searchScore: json["@search.score"].toDouble(),
    status: json["Status"],
    emailId: json["EMAIL_ID"],
    fullName: json["FULL_NAME"],
    merchantName: json["MERCHANT_NAME"],
    transactionDate: DateTime.parse(json["TRANSACTION_DATE"]),
    tax: json["TAX"],
    total: json["TOTAL"],
    discount: json["Discount"],
    blobUrl: json["BLOB_URL"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    itemName: json["ITEM_NAME"],
    sku: json["SKU"],
    price: json["PRICE"],
    expr2: json["Expr2"],
    id: json["ID"],
  );

  Map<String, dynamic> toJson() => {
    "@search.score": searchScore,
    "Status": status,
    "EMAIL_ID": emailId,
    "FULL_NAME": fullName,
    "MERCHANT_NAME": merchantName,
    "TRANSACTION_DATE": transactionDate.toIso8601String(),
    "TAX": tax,
    "TOTAL": total,
    "Discount": discount,
    "BLOB_URL": blobUrl,
    "CreatedDate": createdDate.toIso8601String(),
    "ITEM_NAME": itemName,
    "SKU": sku,
    "PRICE": price,
    "Expr2": expr2,
    "ID": id,
  };
}