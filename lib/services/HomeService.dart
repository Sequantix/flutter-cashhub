import 'dart:convert';

Homedata homedataFromJson(String str) => Homedata.fromJson(json.decode(str));

String homedataToJson(Homedata data) => json.encode(data.toJson());

class Homedata {
  Homedata({
    this.status,
    this.products,
    this.disoct,
  });

  String status;
  List<Product> products;
  int disoct;

  factory Homedata.fromJson(Map<String, dynamic> json) => Homedata(
    status: json["status"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    disoct: json["disoct"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "disoct": disoct,
  };
}

class Product {
  Product({
    this.tdate,
    this.store,
    this.pname,
    this.mid,
    this.mdisocunt,
  });

  String tdate;
  String store;
  int pname;
  int mid;
  int mdisocunt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    tdate: json["tdate"],
    store: json["store"],
    pname: json["pname"],
    mid: json["mid"],
    mdisocunt: json["mdisocunt"],
  );

  Map<String, dynamic> toJson() => {
    "tdate": tdate,
    "store": store,
    "pname": pname,
    "mid": mid,
    "mdisocunt": mdisocunt,
  };
}