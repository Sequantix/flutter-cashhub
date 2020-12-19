// To parse this JSON data, do
//
//     final homePageStore = homePageStoreFromJson(jsonString);

import 'dart:convert';

HomePageStore homePageStoreFromJson(String str) => HomePageStore.fromJson(json.decode(str));

String homePageStoreToJson(HomePageStore data) => json.encode(data.toJson());

class HomePageStore {
  HomePageStore({
    this.status,
    this.products,
  });

  String status;
  Products products;

  factory HomePageStore.fromJson(Map<String, dynamic> json) => HomePageStore(
    status: json["status"],
    products: Products.fromJson(json["products"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "products": products.toJson(),
  };
}

class Products {
  Products({
    this.mname,
    this.tdate,
    this.mTotal,
    this.mtax,
    this.mdiscount,
    this.mblob,
    this.itemModels,
  });

  String mname;
  String tdate;
  int mTotal;
  int mtax;
  int mdiscount;
  String mblob;
  List<ItemModel> itemModels;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    mname: json["mname"],
    tdate: json["tdate"],
    mTotal: json["mTotal"],
    mtax: json["mtax"],
    mdiscount: json["mdiscount"],
    mblob: json["mblob"],
    itemModels: List<ItemModel>.from(json["itemModels"].map((x) => ItemModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mname": mname,
    "tdate": tdate,
    "mTotal": mTotal,
    "mtax": mtax,
    "mdiscount": mdiscount,
    "mblob": mblob,
    "itemModels": List<dynamic>.from(itemModels.map((x) => x.toJson())),
  };
}

class ItemModel {
  ItemModel({
    this.iName,
    this.isku,
    this.iPrice,
  });

  String iName;
  String isku;
  String iPrice;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    iName: json["iName"],
    isku: json["isku"],
    iPrice: json["iPrice"],
  );

  Map<String, dynamic> toJson() => {
    "iName": iName,
    "isku": isku,
    "iPrice": iPrice,
  };
}
